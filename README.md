# Dotfiles Configuration with Chezmoi

This repository contains my personal dotfiles managed by [chezmoi](https://www.chezmoi.io/). It includes configuration for development tools, shell environments, and various applications.

## Quick Start

**Option 1: One-liner (Recommended)**
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

Replace `$GITHUB_USERNAME` with your actual GitHub username.

**Answer the prompts** (for both options):
   - **Email**: Your email address (used for Git configuration)
   - **Location**: Choose between `basil` or `thyme` (determines machine-specific packages)

**Install Homebrew packages**:
   ```bash
   brew bundle --file ~/.Brewfile
   ```
