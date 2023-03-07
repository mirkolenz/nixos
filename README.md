# NixOS Setup

## Nix-Darwin

1. `xcode-select --install`
2. [Homebrew](https://brew.sh)
3. [Nix](https://github.com/DeterminateSystems/nix-installer)

```shell
cd ~/.config/darwin
# First invokation
nix build .\#darwinConfigurations.Mirkos-Mac.system
./result/sw/bin/darwin-rebuild switch --flake .
chsh -s /run/current-system/sw/bin/fish
# Later invokations
darwin-rebuild switch --flake .
```
