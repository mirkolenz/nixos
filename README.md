# NixOS Setup

```shell
nix-shell -p git
sudo nixos-rebuild switch --flake LOCATION
```

## Hash Password

docker run -it --rm alpine mkpasswd PASSWORD

## Building

- [Enable cross compilation](https://github.com/multiarch/qemu-user-static): `docker run --rm --privileged multiarch/qemu-user-static --reset -p yes`
- <https://jade.fyi/blog/nixos-disk-images-m1/>

## One-shot commands

```shell
docker build --tag nixos .
docker run --rm -t --volume $(pwd):/etc/nixos nixos nix --version
```

## Enable caching

```shell
# Enter a nix-enabled shell
docker rm nixos
docker build --tag nixos .
docker run --name nixos --volume $(pwd):/etc/nixos nixos sleep infinity
docker exec -t nixos nix --version
```

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
