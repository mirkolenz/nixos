{
  inputs,
  lib',
  config,
  ...
}:
final: prev:
let
  inherit (final.pkgs) system;
  inherit (prev) lib;
  os = lib'.self.systemOs system;
  importArgs = {
    inherit system config;
  };
in
{
  nixpkgs = import inputs.nixpkgs importArgs;
  nixpkgs-texlive = import inputs.nixpkgs-texlive importArgs;
}
// (lib.genAttrs
  [
    "stable"
    "unstable"
  ]
  (
    channel:
    let
      nixpkgsInput = lib'.self.systemInput {
        inherit inputs channel os;
        name = "nixpkgs";
      };
    in
    import nixpkgsInput importArgs
  )
)
// (lib.concatMapAttrs (
  channel: packages: lib.genAttrs packages (package: final.${channel}.${package})
) (import ./overrides.nix))
