{
  inputs,
  self,
  ...
}:
final: prev:
let
  inherit (prev.stdenv.hostPlatform) system;
  inherit (prev) lib;
  customPackages = lib.packagesFromDirectoryRecursive {
    inherit (final) callPackage;
    directory = ./packages;
  };
in
{
  flake-exports = customPackages;
  inherit (self.packages.${system})
    nixvim
    nixvim-unstable
    nixvim-stable
    treefmt-nix
    ;
  arguebuf = inputs.arguebuf.packages.${system}.default;
  caddy = final.nixpkgs.caddy;
  caddy-custom-docker = final.caddy-docker.override { caddy = final.caddy-custom; };
  dummy = final.writeShellScriptBin "dummy" ":";
  mkApp = final.callPackage ./make-app.nix { };
  nixfmt = final.nixfmt-rfc-style;
  uv-bin = inputs.uv2nix.packages.${system}.uv-bin;
}
// (lib.optionalAttrs (inputs.cosmic-manager.packages ? ${system}) {
  inherit (inputs.cosmic-manager.packages.${system}) cosmic-manager;
})
// customPackages
