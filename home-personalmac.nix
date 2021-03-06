{ pkgs, ... }: let
  nixProfileDir = (builtins.getEnv "HOME") + "/.nix-profile";
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [ ./common.nix ];

  home = {
    packages = [ pkgs.pinentry_mac ];
  };

  home.file.".gnupg/gpg-agent.conf".text = ''
pinentry-program ${nixProfileDir}/${pkgs.pinentry_mac.binaryPath}
max-cache-ttl 18000
default-cache-ttl 18000
  '';
  home.file."Library/KeyBindings/DefaultKeyBinding.dict".source = ./mac-keybindings.dict;
  programs.git = {
    userName = "Johann Dahm";
    userEmail = "johann.dahm@gmail.com";
  };
}
