#!/usr/bin/env fish

if test (count $argv) -ne 1
 echo "USAGE: get_brew_desc.sh <pkg>"
 exit 1
end

brew info $argv[1] --json | jq -r ".[0].desc"
