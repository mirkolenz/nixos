nixpkgs: {
  # https://github.com/nix-community/nixos-generators/blob/master/formats/sd-aarch64-installer.nix
  "custom-sd" = {
    imports = [
      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    ];
    formatAttr = "sdImage";
  };
  # https://github.com/nix-community/nixos-generators/blob/master/formats/install-iso.nix
  "custom-iso" = {
    imports = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ];
    formatAttr = "isoImage";
  };
}
