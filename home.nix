{
  inputs,
  pkgs,
  primaryUser,
  config,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = primaryUser.handle;
  home.homeDirectory = "/Users/${primaryUser.handle}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.tldr
    pkgs.git
    pkgs.helix
    pkgs.vim

    pkgs.just
    pkgs.eza
    pkgs.jq
    pkgs.yq

    pkgs.ghq

    pkgs.google-cloud-sdk
    pkgs.postgresql

    pkgs.jetbrains-mono

    pkgs.spotify

    # Language servers
    pkgs.nixd
    pkgs.alejandra

    pkgs.gopls
    pkgs.delve

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/johannd/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    preferAbbrs = true;
    plugins = [
      # {
      #   name = "hydro";
      #   inherit (pkgs.fishPlugins.hydro) src;
      # }
      {
        name = "done";
        inherit (pkgs.fishPlugins.done) src;
      }
      {
        name = "autopair";
        inherit (pkgs.fishPlugins.autopair) src;
      }
      {
        name = "spark";
        inherit (pkgs.fishPlugins.spark) src;
      }
      {
        name = "sponge";
        inherit (pkgs.fishPlugins.sponge) src;
      }
    ];
    shellInit = ''
      set --global hydro_color_git green
      set --global hydro_color_duration yellow
      set --global hydro_color_prompt blue
      set --global hydro_color_pwd magenta

      set sponge_purge_only_on_exit true

      fish_add_path -p $HOME/bin
    '';
  };

  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      nix_shell = {
        impure_msg = "";
      };
      gcloud = {
        disabled = false;
        detect_env_vars = ["GOOGLE_CLOUD" "GCLOUD"];
      };
      kubernetes = {
        disabled = false;
        detect_env_vars = ["GOOGLE_CLOUD" "GCLOUD"];
      };
      sudo = {
        disabled = false;
      };
    };
  };

  programs.gh = {
    enable = true;
    extensions = [pkgs.gh-poi];
    settings = {
      git_protocol = "https";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry_mac;
  };

  programs.go.enable = true;

  programs.helix.enable = true;

  programs.zed-editor = {
    enable = true;
  };

  # Zed needs a fish symlink.
  home.file."bin/fish".source = "${pkgs.fish}/bin/fish";
  home.file.".config/zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/github.com/jdahm/dotfiles/.config/zed/settings.json";
  home.file.".config/zed/keymap.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/github.com/jdahm/dotfiles/.config/zed/keymap.json";

  programs.git = {
    enable = true;
    delta.enable = true;
    ignores = [
      "*~"
      ".DS_Store"
      ".vscode"
      ".direnv"
      ".envrc"
      "shell.nix"
      ".experiments/"
      ".idea/"
    ];
    lfs.enable = true;
    userEmail = primaryUser.email;
    userName = primaryUser.name;
    signing = {
      format = "openpgp";
      signByDefault = true;
    };
    extraConfig = {
      ghq = {
        root = "~/dev";
      };
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = primaryUser.name;
        email = primaryUser.email;
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global = {
        load_dotenv = true;
      };
    };
  };

  programs.kitty = {
    enable = true;
    shellIntegration.mode = "enabled";
    font = {
      name = "Monaspace Argon";
      package = pkgs.monaspace;
      size = 16;
    };
    settings = {
      fish_greeting = "";
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "yes";
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "round"; # angled, slanted, round
      allow_remote_control = "yes";
      modify_font = "cell_height 110%";
      shell = "${pkgs.fish}/bin/fish --login";
    };
    keybindings = {
      "f1" = "new_window_with_cwd";
      "f2" = "launch --cwd=current $EDITOR .";
    };
    themeFile = "nord";
  };
}
