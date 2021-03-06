# Dotfiles

My dotfiles are managed using [home-manager](https://github.com/nix-community/home-manager) and [nix](https://nixos.org/).

## Deploy

To install on a system, first ensure `nix` and `home-manager` are installed:

```bash
$ sh <(curl -L https://nixos.org/nix/install) --daemon
$ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
$ nix-channel --update
$ nix-shell '<home-manager>' -A install
```

Then clone and link the dotfiles, and select the profile for the system.

```bash
$ git clone git@github.com:jdahm/dotfiles.git
$ mkdir -p ~/.config && ln -s $(pwd)/dotfiles ~/.config/nixpkgs
$ cd dotfiles && ln -s home-<profile>.nix home.nix
```

Finally, a generation can be created by running home-manager:

```bash
$ home-manager switch
```
