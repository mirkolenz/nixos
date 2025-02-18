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
    inherit (final) callPackage;
    directory = ./packages;
  };
in
{
  exported-packages = exportedPackages;
  inherit (self.packages.${system})
    # nixvim-stable
    nixvim-unstable
    treefmt-nix
    ;
  nixvim = final.nixvim-unstable;
  arguebuf = inputs.arguebuf.packages.${system}.default;
  caddy = final.nixpkgs.caddy;
  caddy-custom-docker = final.caddy-docker.override { caddy = final.caddy-custom; };
  dummy = final.writeShellScriptBin "dummy" ":";
  nixfmt = final.nixfmt-rfc-style;
  uv-bin = inputs.uv2nix.packages.${system}.uv-bin;
}
// (lib.optionalAttrs (inputs.cosmic-manager.packages ? ${system}) {
  inherit (inputs.cosmic-manager.packages.${system}) cosmic-manager;
})
// exportedPackages
