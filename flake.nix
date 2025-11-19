# Sources:
# - https://github.com/HestHub/nixos
# - https://github.com/evantravers/dotfiles
# - https://github.com/dustinlyons/nixos-config
{
  description = "Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # ({
  #   config,
  #   lib,
  # }: {
  #   options = {
  #     dotfiles = lib.mkOption {
  #       type = lib.types.path;
  #       apply = toString;
  #       default = "${config.home.homeDirectory}/.dotfiles";
  #       example = "${config.home.homeDirectory}/.dotfiles";
  #       description = "Location of the dotfiles working copy";
  #     };
  #   };
  # })

  outputs = inputs @ {
    self,
    nix-darwin,
    home-manager,
  }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#basil
    darwinConfigurations."Johann-Dahm-MacBook-Pro" = nix-darwin.lib.darwinSystem (let
      primaryUser = {
        name = "Johann Dahm";
        handle = "johannd";
        email = "johannd@allenai.org";
      };
    in {
      system = "aarch64-darwin";
      modules = [
        ./configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm.backup";
          home-manager.users.${primaryUser.handle} = ./home.nix;
          home-manager.extraSpecialArgs = {inherit inputs self primaryUser;};

          imports = [./homebrew.nix];
        }
      ];
      specialArgs = {inherit inputs self primaryUser;};
    });

    darwinConfigurations."basil" = nix-darwin.lib.darwinSystem (let
      primaryUser = {
        name = "Johann Dahm";
        handle = "jdahm";
        email = "johann.dahm@gmail.com";
      };
    in {
      system = "aarch64-darwin";
      modules = [
        ./configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm.backup";
          home-manager.users.${primaryUser.handle} = ./home.nix;
          home-manager.extraSpecialArgs = {inherit inputs self primaryUser;};

          imports = [./homebrew.nix];
        }
      ];
      specialArgs = {inherit inputs self primaryUser;};
    });
  };
}
