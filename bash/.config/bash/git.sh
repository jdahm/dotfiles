#!/usr/bin/env bash

git-make-test() {
    local branch="$(git branch | sed -n '/\* /s///p')"
    local args="-m Test from $(uname -n) on $branch at $(date +%F-%H:%M:%S)"
    if [ "$1" = "-a" ]; then
        git add -A
        shift
    fi
    git checkout -b "$1"
    git commit "$args"
    git checkout "$branch"
}

git-list-branches() {
    # USAGE: if local:  git-list-branches pat dir
    #        if remote: git-list-branches pat -r remote dir
    local gitcmd="git branch --list '$1' | sed 's/^[\* ] *//g'"
    if [ "$2" = "-r" ]; then
        eval "ssh $3 \"cd $4; $gitcmd\"" 2>/dev/null
    else
        (cd "$2" && eval "$gitcmd")
    fi
}

git-rm-branches() {
    # USAGE: if local:  git-rm-branches [-f] pat dir
    #        if remote: git-rm-branches [-f] pat -r remote dir
    #   -f : [optional] if exists, force branch removal even when not fully merged
    local rmflag="-d" remote dir branches gitcmd
    if [ "$1" = "-D" ]; then
        rmflag="$1"
        shift
    fi
    if [ "$2" = "-r" ]; then
        remote="$3"
        dir="$4"
    else
        dir="$2"
    fi
    branches=($(git-list-branches "$@"))
    gitcmd="git branch $rmflag ${branches[@]}"
    if [ -n "$remote" ]; then
        eval "ssh $remote \"cd $dir; $gitcmd\"" 2>/dev/null
    else
        (cd "$dir" && eval "$gitcmd")
    fi
}

git-test-oneshot() {
    # USAGE: git-test-oneshot branchname remote dir
    # Assumes bare repo is named origin for both working repos
    local branchname="$1"
    git-make-test -a "$branchname"
    git push origin "$branchname"
    ssh "$2" "cd $3; git fetch origin; git stash; git checkout -b $branchname origin/$branchname"
}
