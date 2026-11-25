#!/bin/sh
# Build Helix from source at a pinned commit.
# The cargo build also fetches and compiles the tree-sitter grammars into ~/helix/runtime.
set -eu

commit=1a3fdfda6dfdda4567af6093a6249bb2bb422fc6

if [ ! -d ~/helix ]; then
    git clone https://github.com/helix-editor/helix ~/helix
fi
git -C ~/helix fetch origin
git -C ~/helix switch --detach "$commit"

cargo install --path ~/helix/helix-term --locked

# hx looks for themes, queries and grammars in ~/.config/helix/runtime
mkdir -p ~/.config/helix
ln -sfn ~/helix/runtime ~/.config/helix/runtime

hx --health | head -n 5
