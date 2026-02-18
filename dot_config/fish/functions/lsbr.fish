function lsbr --description "Display local branches with git colors, sorted by commit date, adapted to terminal width"
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository" >&2
        return 1
    end

    # Get terminal width
    set -l term_width (tput cols)

    # Use Fish's set_color for proper color handling
    set -l yellow (set_color yellow)
    set -l blue (set_color blue)
    set -l green (set_color green)
    set -l gray (set_color brblack)
    set -l reset (set_color normal)

    # Check if git-town is installed
    set -l has_git_town 0
    if command -v git-town >/dev/null 2>&1
        set has_git_town 1
    end

    # Get branches sorted by commit date (newest first), limit to 30
    # Also get authordate as unix timestamp for sorting siblings
    # Note: using -g because nested helper functions need access
    set -g branch_lines
    for line in (git for-each-ref --sort=-authordate refs/heads/ --format="%(HEAD)|%(refname:short)|%(contents:subject)|%(authorname)|%(authordate:relative)|%(upstream:short)|%(authordate:unix)")
        set -a branch_lines $line
    end

    # Fetch all parent branches upfront if git-town is available
    set -l branch_lines_with_parents
    set -l has_any_parents 0
    if test $has_git_town -eq 1
        # Get all parent branches in one git config call
        set -l parent_configs (git config --get-regexp '^git-town-branch\..*\.parent$' 2>/dev/null)

        for line in $branch_lines
            set -l parts (string split "|" $line)
            set -l branch_name $parts[2]
            set -l parent_branch ""

            # Search for this branch's parent in the config output
            for config_line in $parent_configs
                # Extract branch name from: git-town-branch.BRANCH_NAME.parent PARENT_VALUE
                set -l config_branch (string replace -r '^git-town-branch\.(.+)\.parent .*$' '$1' $config_line)
                if test "$config_branch" = "$branch_name"
                    set parent_branch (string replace -r '^git-town-branch\..*\.parent (.+)$' '$1' $config_line)
                    set has_any_parents 1
                    break
                end
            end

            set -a branch_lines_with_parents "$line|$parent_branch"
        end
        set branch_lines $branch_lines_with_parents
    else
        # No git-town, just append empty parent to each line
        set -l temp_lines
        for line in $branch_lines
            set -a temp_lines "$line|"
        end
        set branch_lines $temp_lines
    end

    # Build tree structure if we have parent info
    # Format: is_current|branch_name|subject|author|date|upstream|timestamp|parent
    set -g ordered_branches
    set -g branch_depths

    if test $has_any_parents -eq 1
        # Build maps for tree traversal
        # We need to find all branches and their parents, then traverse depth-first

        # Create list of all branch names for quick lookup
        set -l all_branch_names
        for line in $branch_lines
            set -l parts (string split "|" $line)
            set -a all_branch_names $parts[2]
        end

        # Helper function to get children of a parent, sorted by date (newest first)
        # Children are branches whose parent matches and the parent is in our branch list
        function __lsbr_get_children --argument-names parent_name
            set -l children
            set -l child_timestamps
            for line in $branch_lines
                set -l parts (string split "|" $line)
                set -l branch_name $parts[2]
                set -l branch_parent $parts[8]
                set -l timestamp $parts[7]
                if test "$branch_parent" = "$parent_name"
                    set -a children $branch_name
                    set -a child_timestamps $timestamp
                end
            end
            # Return early if no children
            if test (count $children) -eq 0
                return
            end
            # Sort children by timestamp (descending - newest first)
            # Build index-timestamp pairs, sort by timestamp, extract by index
            set -l sorted_indices
            for i in (seq (count $children))
                echo "$child_timestamps[$i] $i"
            end | sort -rn | while read -l ts idx
                set -a sorted_indices $idx
            end
            # Output children in sorted order
            for idx in $sorted_indices
                echo $children[$idx]
            end
        end

        # Find root branches (no parent, or parent not in our list)
        set -l root_branches
        set -l root_timestamps
        for line in $branch_lines
            set -l parts (string split "|" $line)
            set -l branch_name $parts[2]
            set -l branch_parent $parts[8]
            set -l timestamp $parts[7]
            set -l is_root 1
            if test -n "$branch_parent"
                # Check if parent is in our branch list
                for b in $all_branch_names
                    if test "$b" = "$branch_parent"
                        set is_root 0
                        break
                    end
                end
            end
            if test $is_root -eq 1
                set -a root_branches $branch_name
                set -a root_timestamps $timestamp
            end
        end

        # Sort root branches by date (newest first)
        set -l sorted_roots
        if test (count $root_branches) -gt 0
            set -l sorted_indices
            for i in (seq (count $root_branches))
                echo "$root_timestamps[$i] $i"
            end | sort -rn | while read -l ts idx
                set -a sorted_indices $idx
            end
            for idx in $sorted_indices
                set -a sorted_roots $root_branches[$idx]
            end
        end

        # Depth-first traversal to build ordered list
        function __lsbr_traverse --argument-names branch_name depth
            # Add this branch with its depth
            set -g ordered_branches $ordered_branches $branch_name
            set -g branch_depths $branch_depths $depth

            # Get and traverse children
            set -l children (__lsbr_get_children $branch_name)
            for child in $children
                __lsbr_traverse $child (math $depth + 1)
            end
        end

        # Traverse from each root
        for root in $sorted_roots
            __lsbr_traverse $root 0
        end

        # Clean up helper functions
        functions -e __lsbr_get_children
        functions -e __lsbr_traverse

        # Reorder branch_lines according to ordered_branches
        set -l reordered_lines
        for branch_name in $ordered_branches
            for line in $branch_lines
                set -l parts (string split "|" $line)
                if test "$parts[2]" = "$branch_name"
                    set -a reordered_lines $line
                    break
                end
            end
        end
        set branch_lines $reordered_lines
    else
        # No tree structure, use flat list with depth 0
        for line in $branch_lines
            set -a branch_depths 0
        end
    end

    # Calculate max indentation
    set -l max_indent 0
    for depth in $branch_depths
        if test $depth -gt $max_indent
            set max_indent $depth
        end
    end
    set -l indent_width 2 # spaces per indent level

    # Find the longest branch name, parent, and subject for alignment
    set -l max_branch_name_width 0
    set -l max_parent_width 0
    set -l max_subject_width 0
    set -l idx 0
    for line in $branch_lines
        set idx (math $idx + 1)
        set -l parts (string split "|" $line)
        set -l branch_name $parts[2]
        set -l subject $parts[3]
        set -l parent_branch $parts[8]

        # Get depth for this branch
        set -l depth $branch_depths[$idx]

        # Calculate branch name width including indentation
        set -l branch_name_width (math 2 + (string length $branch_name) + $depth "*" $indent_width) # "* " + indent + name

        # Calculate parent width if parent exists (only in flat mode)
        set -l parent_width 0
        if test $has_any_parents -eq 0; and test -n "$parent_branch"
            set parent_width (math 3 + (string length $parent_branch)) # " ()" + parent
        end

        set -l subject_len (string length $subject)
        if test $branch_name_width -gt $max_branch_name_width
            set max_branch_name_width $branch_name_width
        end
        if test $parent_width -gt $max_parent_width
            set max_parent_width $parent_width
        end
        if test $subject_len -gt $max_subject_width
            set max_subject_width $subject_len
        end
    end

    # Total max width is branch name + parent
    set -l max_branch_width (math $max_branch_name_width + $max_parent_width)

    # Process and display each branch
    set -l branch_idx 0
    for line in $branch_lines
        set branch_idx (math $branch_idx + 1)
        set -l parts (string split "|" $line)
        set -l is_current $parts[1]
        set -l branch_name $parts[2]
        set -l subject $parts[3]
        set -l author $parts[4]
        set -l date $parts[5]
        set -l upstream $parts[6]
        set -l parent_branch $parts[8]

        # Get depth for this branch
        set -l depth $branch_depths[$branch_idx]

        # Create indentation
        set -l indent ""
        if test $depth -gt 0
            set indent (string repeat -n (math $depth "*" $indent_width) " ")
        end

        # Create branch display with marker and color
        set -l marker "  "
        if test "$is_current" = "*"
            set marker "* "
        end

        # Calculate current branch name width including indentation
        set -l branch_name_width (math 2 + (string length $branch_name) + $depth "*" $indent_width) # "* " + indent + name

        # Get parent display if parent exists (only in flat mode, not tree mode)
        set -l parent_display ""
        set -l parent_width 0
        if test $has_any_parents -eq 0; and test -n "$parent_branch"
            set parent_display "$gray($parent_branch)$reset"
            set parent_width (math 3 + (string length $parent_branch)) # " ()" + parent
        end

        # Padding between branch name and parent to align parents (only if parent exists)
        set -l branch_to_parent_padding ""
        if test $parent_width -gt 0
            set -l branch_to_parent_padding_count (math $max_branch_name_width - $branch_name_width + 1)
            if test $branch_to_parent_padding_count -lt 1
                set branch_to_parent_padding_count 1
            end
            set branch_to_parent_padding (string repeat -n $branch_to_parent_padding_count " ")
        else
            # No parent, just pad to where parents would end
            set -l total_padding_count (math $max_branch_name_width - $branch_name_width + $max_parent_width)
            if test $total_padding_count -lt 0
                set total_padding_count 0
            end
            set branch_to_parent_padding (string repeat -n $total_padding_count " ")
        end

        # Padding after parent to align subjects (only needed if parent exists)
        set -l parent_padding ""
        if test $parent_width -gt 0
            set -l parent_padding_count (math $max_parent_width - $parent_width)
            set parent_padding (string repeat -n $parent_padding_count " ")
        end

        # Check if branch has upstream - use green if it does, yellow if not
        set -l branch_color $yellow
        if test -n "$upstream"
            set branch_color $green
        end

        # Combine branch name and parent with their padding
        set -l branch_part "$marker$indent$branch_color$branch_name$reset$branch_to_parent_padding$parent_display$parent_padding"

        # Calculate space for author/date part
        set -l author_len (string length $author)
        set -l date_len (string length $date)
        if test -z "$author_len"
            set author_len 0
        end
        if test -z "$date_len"
            set date_len 0
        end
        set -l author_date_width (math $author_len + $date_len + 3) # author + " ()" + date

        # Check if everything fits with alignment after longest subject
        set -l total_width_needed (math $max_branch_width + $max_subject_width + $author_date_width + 4) # +4 for spacing

        set -l display_subject $subject
        set -l current_subject_len (string length $subject)
        if test -z "$current_subject_len"
            set current_subject_len 0
        end

        set -l gap_padding

        if test $total_width_needed -le $term_width
            # Everything fits - align after longest subject
            set -l gap_width (math $max_subject_width - $current_subject_len + 2)
            if test $gap_width -lt 2
                set gap_width 2
            end
            set gap_padding (string repeat -n $gap_width " ")
        else
            # Need to truncate - use original right-aligned behavior
            set -l fixed_width (math $max_branch_width + $author_date_width + 4) # +4 for spacing
            set -l subject_width (math $term_width - $fixed_width)
            if test $subject_width -lt 10
                set subject_width 10
            end

            # Truncate subject if needed
            if test $current_subject_len -gt $subject_width
                set display_subject (string sub --length (math $subject_width - 3) $subject)"..."
                set current_subject_len (string length $display_subject)
                if test -z "$current_subject_len"
                    set current_subject_len 0
                end
            end

            # Calculate spacing between subject and author for right alignment
            set -l gap_width (math $subject_width - $current_subject_len + 2)
            if test $gap_width -lt 2
                set gap_width 2
            end
            set gap_padding (string repeat -n $gap_width " ")
        end

        # Output the complete line
        printf "%s %s%s%s%s%s (%s%s%s)\n" \
            $branch_part \
            $display_subject \
            $gap_padding \
            $blue $author $reset \
            $green $date $reset
    end

    # Clean up global variables
    set -e ordered_branches
    set -e branch_depths
    set -e branch_lines
end
