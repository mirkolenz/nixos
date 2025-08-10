{ ... }:
final: prev: {
  nixos-rebuild-ng = prev.nixos-rebuild-ng.override {
    nix = final.determinate-nix;
  };
}
