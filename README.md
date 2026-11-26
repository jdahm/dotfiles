# dotfiles

My config for fish, git, Helix, Zed, Ghostty and friends, for macOS and Linux.
[dotbot](https://github.com/anishathalye/dotbot) links the files into place and runs the tool installers.

## Setup

On Linux, install git, curl, fish and a C compiler first (`apt install git curl fish build-essential` on Debian or Ubuntu).
On macOS, install [Homebrew](https://brew.sh).

```sh
git clone git@github.com:jdahm/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install
```

`./install` is safe to run again. It:

- links the config files into `~` and `~/.config` (see `install.conf.yaml`)
- installs rustup, uv and mise with their own installers
- installs the command-line tools listed in `mise/config.toml`
- installs Harlequin and Ansible with uv

Then finish by hand:

1. On macOS, install the apps and remaining formulae: `brew bundle --global`.
2. Install the fish plugins in `fish/fish_plugins`. Homebrew installs fisher on macOS. On Linux, install it first:
   ```fish
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update
   ```
   On macOS, just run `fisher update`.
3. Build Helix: `helix/install.sh`. It builds a pinned commit from source.
4. Add your git name and email to `~/.config/git/identity`, which `git/config` includes:
   ```ini
   [user]
   	name = Your Name
   	email = you@example.com
   ```
5. In Rex, set the terminal font to JetBrainsMono Nerd Font (Settings › Terminal › Typography). Rex keeps it in the app, not in a file.

## Where tools come from

| Source | What | Update with |
|---|---|---|
| `mise/config.toml` | most command-line tools (go, node, gh, jq, kubectl, …) | `mise upgrade` |
| Their own installers, in `install.conf.yaml` | rustup, uv, mise, Claude Code | `rustup update`, `uv self update`, `mise self-update`, `claude update` |
| uv | Harlequin, Ansible | `uv tool upgrade --all` |
| `homebrew/Brewfile` (macOS only) | apps, fonts, and a few formulae like git, fish and libpq | `brew bundle --global` |
| `helix/install.sh` | Helix, built from source | change the commit in the script and rerun it |

mise tools are on `PATH` through mise's shims, so scripts and editors see them too.
Tools I don't install by default, but might want again, are in `extra-tools.md`.

## Files

Each app has its own folder, and each file keeps the name it has where it's linked.
The top level only holds the installer, its config and the docs.

| Folder | Linked to |
|---|---|
| `fish/` | `~/.config/fish/` |
| `git/` | `~/.config/git/` |
| `helix/` | `~/.config/helix/config.toml` and `languages.toml` (and `install.sh` builds Helix) |
| `mise/` | `~/.config/mise/config.toml` |
| `starship/` | `~/.config/starship.toml` |
| `atuin/` | `~/.config/atuin/config.toml` |
| `jj/` | `~/.config/jj/config.toml` |
| `vim/`, `ideavim/` | `~/.vimrc`, `~/.ideavimrc` |
| `homebrew/` | `~/.Brewfile` (macOS only) |
| `ghostty/` | `~/.config/ghostty/config` (macOS only) |
| `zed/` | `~/.config/zed/` (macOS only) |
| `gnupg/` | `~/.gnupg/gpg-agent.conf` (macOS only) |
| `emacs/` | not linked |

Machine-specific fish config goes in `~/.config/fish/local.fish`, which `config.fish` sources if it exists.
