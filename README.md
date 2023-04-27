# NixOS Setup

## NixOS

1. Install NixOS with provided ISO
2. Create config: `nixos-generate-config`
3. Migrate generated `/etc/nixos/configuration.nix` and `/etc/nixos/hardware-configuration.nix` to this flake manually
4. Eventually install git in a temporary shell: `nix-shell -p git`

```shell
# Large changes (like first time)
sudo nixos-rebuild --flake github:mirkolenz/nixos#MACHINE_NAME boot
# Small changes
sudo nixos-rebuild --flake github:mirkolenz/nixos#MACHINE_NAME switch
```

## Nix-Darwin

1. `xcode-select --install`
2. [Homebrew](https://brew.sh)
3. [Nix](https://github.com/DeterminateSystems/nix-installer)
4. Enable Full Disk Access for terminal application

```shell
# First invokation
nix build github:mirkolenz/nixos#darwinConfigurations.MACHINE_NAME.system
./result/sw/bin/darwin-rebuild --flake github:mirkolenz/nixos#MACHINE_NAME switch
# You could get the following error: error: Directory /run does not exist, aborting activation
# You need to run apfs.util with sudo, otherwise you will get this error:
# failed to stitch firmlinks and/or create synthetics for root volume (c00d) ...
# You may need to manually remove some existing files like the following
# ATTENTION: Do not close the shell before incoking darwin-rebuild again, otherwise your path may be broken
sudo rm /etc/bashrc /etc/shells /etc/zshrc /etc/nix/nix.conf
# Activate again
./result/sw/bin/darwin-rebuild --flake github:mirkolenz/nixos#MACHINE_NAME switch
chsh -s /run/current-system/sw/bin/fish
sudo reboot
# Add all ssh keys to keychain
ssh-add --apple-load-keychain ~/.ssh/KEY_NAME
# Later invokations
darwin-rebuild --flake github:mirkolenz/nixos#MACHINE_NAME switch
```

## NixOS Generators

**Important:** [Enable cross compiling](https://github.com/nix-community/nixos-generators#cross-compiling)

```shell
nix build --system SYSTEM github:mirkolenz/nixos#FORMAT
```

## Hash Password

docker run -it --rm alpine mkpasswd PASSWORD
