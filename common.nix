{ pkgs, ... }:
let
  getEnvDefault = var: default:
    if builtins.getEnv var != "" then builtins.getEnv var else default;

  homeDirectory = builtins.getEnv "HOME";
  username = builtins.getEnv "USER";
  editor = "emacs";
  nixpkgsConfDir = homeDirectory + "/.config/nixpkgs";
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "21.05";
    packages = with pkgs; [
      hack-font
      fira-code

      git-crypt
      delta
      gh

      pinentry_mac

      curl
      rsync
      wget

      nixfmt

      ghc
      cabal-install
      stack
      cachix

      google-cloud-sdk
      tmux

      tree
      htop

      emacs
      vscode
    ];
    sessionVariables = {
      EDITOR = editor;
      VISUAL = editor;
    };
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    delta.enable = true;
    lfs.enable = true;
    ignores = [ "*~" ".DS_Store" ".vscode" ".direnv" ".envrc" "shell.nix" ];
    extraConfig = {
      core = { editor = "nano"; };
      url = { "git@github.com:" = { insteadOf = "https://github.com/"; }; };
      pull = { rebase = true; };
      fetch = { prune = true; };
      push = { default = "upstream"; };
    };
  };

  programs.zsh = {
    enable = true;
    prezto.enable = true;
    prezto.prompt.theme = "pure";
    prezto.pmodules = [
      "environment"
      "terminal"
      "editor"
      "history"
      "directory"
      "spectrum"
      "utility"
      "completion"
      "prompt"
      "syntax-highlighting"
      "osx"
      "helper"
      "rsync"
      "tmux"
      "git"
      "autosuggestions"
      "history-substring-search"
      "fasd"
      "archive"
      "gpg"
    ];
    prezto.terminal.autoTitle = true;
    prezto.editor.keymap = "emacs";
    prezto.editor.dotExpansion = true;
    prezto.caseSensitive = true;
    prezto.extraFunctions = [ "zargs" "zmv" ];
    initExtra = ''
      if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi
      if [ -e ~/.zshrc.local ]; then . ~/.zshrc.local; fi'';
  };

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
  };

  programs.gpg = {
    enable = true;
    settings = {
      charset = "utf-8";
      use-agent = true;
    };
  };

  home.file.".emacs.d/init.el".source = ./init.el;
}
