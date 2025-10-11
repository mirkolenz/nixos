final: prev:
prev.nixos-rebuild-ng.override {
  nix = final.determinate-nix;
}
