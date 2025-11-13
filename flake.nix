{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#basil
    darwinConfigurations."Johann-Dahm-MacBook-Pro" = nix-darwin.lib.darwinSystem (let primaryUser = {
      name = "Johann Dahm";
      handle = "johannd";
      email = "johannd@allenai.org";
    }; in {
      system = "aarch64-darwin";
      modules = [
        ./configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm.backup";
          home-manager.users.${primaryUser.handle} = ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs self primaryUser; };

          imports = [ ./homebrew.nix ];
        }
      ];
      specialArgs = { inherit inputs self primaryUser; };
    });

    darwinConfigurations."basil" = nix-darwin.lib.darwinSystem (let primaryUser = {
      name = "Johann Dahm";
      handle = "jdahm";
      email = "johann.dahm@gmail.com";
    }; in {
      system = "aarch64-darwin";
      modules = [
        ./configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm.backup";
          home-manager.users.${primaryUser.handle} = ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs self primaryUser; };

          imports = [ ./homebrew.nix ];
        }
      ];
      specialArgs = { inherit inputs self primaryUser; };
    });
  };
}
