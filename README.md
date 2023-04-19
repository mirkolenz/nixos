# NixOS Setup

## NixOS

1. Install NixOS with provided ISO
2. Migrate generated `/etc/nixos/configuration.nix` and `/etc/nixos/hardware-configuration.nix` to this flake manually
3. Eventually install git in a temporary shell: `nix-shell -p git`

```shell
# Large changes (like first time)
sudo nixos-rebuild boot --flake github:mirkolenz/nixos#MACHINE_NAME
# Small changes
sudo nixos-rebuild switch --flake github:mirkolenz/nixos#MACHINE_NAME
```

## Nix-Darwin

1. `xcode-select --install`
2. [Homebrew](https://brew.sh)
3. [Nix](https://github.com/DeterminateSystems/nix-installer)
4. Enable Full Disk Access for terminal application

```shell
cd ~/.config/darwin
# First invokation
nix build github:mirkolenz/nixos#darwinConfigurations.MACHINE_NAME.system
./result/sw/bin/darwin-rebuild boot --flake github:mirkolenz/nixos#MACHINE_NAME
# Restart
chsh -s /run/current-system/sw/bin/fish
# Later invokations
darwin-rebuild switch --flake github:mirkolenz/nixos#MACHINE_NAME
```

## NixOS Generators

**Important:** [Enable cross compiling](https://github.com/nix-community/nixos-generators#cross-compiling)

```shell
nix build --system SYSTEM github:mirkolenz/nixos#MACHINE_NAME
```

## Hash Password

docker run -it --rm alpine mkpasswd PASSWORD
