{ inputs, lib', ... }:
final: prev:
let
  inherit (final.pkgs) system;
  os = lib'.self.systemOs system;

  mkChannel =
    channel:
    let
      nixpkgs = lib'.self.systemInput {
        inherit inputs channel os;
        name = "nixpkgs";
      };
    in
    import nixpkgs {
      inherit system;
      config = import ../nixpkgs-config.nix;
    };
  useChannel = channel: names: prev.lib.genAttrs names (name: final.${channel}.${name});

  stablePkgs = import ./stable.nix;
  unstablePkgs = import ./unstable.nix;
in
(prev.lib.genAttrs [
  "stable"
  "unstable"
] mkChannel)
// (useChannel "stable" stablePkgs)
// (useChannel "unstable" unstablePkgs)
