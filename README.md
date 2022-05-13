# Dotfiles

My dotfiles are currently managed with [chezmoi](https://www.chezmoi.io/).

## Installation

After installing chezmoi and running `chezmoi apply`, also run

```shell
$ cat ~/.config/fish/fish_plugins | fisher install
```

## MacOS Keyboard Mapping

https://gist.github.com/buckleyc/ce6f2325d1ff2f6e5ed8742f97491e80

```
hidutil property --set '{"UserKeyMapping":[{ "HIDKeyboardModifierMappingSrc": 0x70000002A, "HIDKeyboardModifierMappingDst": 0x700000029},{ "HIDKeyboardModifierMappingSrc": 0x700000039, "HIDKeyboardModifierMappingDst": 0x70000002A}]}'
```

And, to reset the bindings:

```
hidutil property --set '{"UserKeyMapping":[]}'
```
