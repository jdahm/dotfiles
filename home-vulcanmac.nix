{ pkgs, ... }:
let nixProfileDir = (builtins.getEnv "HOME") + "/.nix-profile";
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [ ./common.nix ];

  home = { packages = [ pkgs.pinentry_mac ]; };

  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program ${nixProfileDir}/${pkgs.pinentry_mac.binaryPath}
    max-cache-ttl 18000
    default-cache-ttl 18000
      '';
  home.file."Library/KeyBindings/DefaultKeyBinding.dict".source =
    ./mac-keybindings.dict;

  home.file.".zshrc.local".text = ''
    function dasm {
        objdump -d $1 | awk -v x=$2 -v RS= '$1 ~ x'
    }

    alias ldd='otool -L' '';

  home.file."Library/Application Support/Code/User/settings.json".source = ./vscode/settings.json;

  programs.git = {
    userName = "Johann Dahm";
    userEmail = "johannd@vulcan.com";
    signing.signByDefault = true;
    signing.gpgPath = "gpg2";
    signing.key = "C0767167AA9F7D22";
  };
}
