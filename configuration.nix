{
  pkgs,
  inputs,
  self,
  primaryUser,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
  ];

  # Let Determinate Nix handle Nix configuration.
  #nix.enable = false;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: _: {
      # this allows you to access `pkgs.unstable` anywhere in your config
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (final) config;
      };
    })
  ];

  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;

  environment.shells = [pkgs.fish];

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.primaryUser = primaryUser.handle;
  users.users.${primaryUser.handle}.home = "/Users/${primaryUser.handle}";

  system.defaults.dock.persistent-apps = [
    {
      app = "/Applications/Safari.app";
    }
    {
      app = "/System/Applications/Mail.app";
    }
    {
      app = "/System/Applications/Messages.app";
    }
    {
      app = "/System/Applications/FaceTime.app";
    }
    {
      app = "/System/Applications/Photos.app";
    }
    {
      app = "/System/Applications/Reminders.app";
    }
    {
      app = "/System/Applications/Notes.app";
    }
    {
      app = "/System/Applications/Passwords.app";
    }
    {
      app = "${pkgs.kitty}/Applications/Kitty.app";
    }
    {
      app = "/Applications/Zed.app";
    }
    {
      app = "${pkgs.tableplus}/Applications/TablePlus.app";
    }
  ];
}
