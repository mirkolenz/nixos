{
  inputs,
  lib',
  nixpkgsConfig,
  ...
}:
final: prev:
let
  inherit (final.pkgs) system;
  inherit (prev) lib;
  os = lib'.self.systemOs system;
in
{
  nixpkgs = import inputs.nixpkgs {
    inherit system;
    config = nixpkgsConfig;
  };
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
    import nixpkgsInput {
      inherit system;
      config = nixpkgsConfig;
    }
  )
)
// (lib.mapAttrs (
  channel: packages: lib.genAttrs packages (package: final.${channel}.${package})
) (import ./overrides.nix))
