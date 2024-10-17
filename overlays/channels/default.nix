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
      config = import ../../nixpkgs-config.nix;
    };
  useChannel = channel: names: prev.lib.genAttrs names (name: final.${channel}.${name});

  packages = import ./packages.nix;
in
(prev.lib.genAttrs [
  "stable"
  "unstable"
  "v2311"
] mkChannel)
// (useChannel "stable" packages.stable)
// (useChannel "unstable" packages.unstable)
