{
  inputs,
  self,
  ...
}:
final: prev:
let
  inherit (prev.stdenv.hostPlatform) system;
  inherit (prev) lib;
  exportedPackages = lib.packagesFromDirectoryRecursive {
    # inherit (prev) newScope;
    callPackage = lib.callPackageWith (final // { inherit inputs; });
    directory = ./packages;
  };
in
{
  exported-packages = lib.filterAttrs (
    _: value: lib.meta.availableOn { inherit system; } value && lib.isDerivation value
  ) exportedPackages;
  inherit (self.packages.${system})
    # nixvim-stable
    nixvim-unstable
    treefmt-nix
    ;
  arguebuf = inputs.arguebuf.packages.${system}.default;
  caddy = final.nixpkgs.caddy;
  caddy-custom-docker = final.caddy-docker.override { caddy = final.caddy-custom; };
  dummy = final.writeShellScriptBin "dummy" ":";
  nix-converter = inputs.nix-converter.packages.${system}.default;
  nixfmt = final.nixfmt-rfc-style;
  nixvim = final.nixvim-unstable;
  uv-bin = inputs.uv2nix.packages.${system}.uv-bin;
}
// (lib.optionalAttrs (inputs.cosmic-manager.packages ? ${system}) {
  inherit (inputs.cosmic-manager.packages.${system}) cosmic-manager;
})
// (lib.optionalAttrs (inputs.angrr.packages ? ${system}) {
  inherit (inputs.angrr.packages.${system}) angrr;
})
// exportedPackages
