inputs: final: prev:
let
  os = if final.stdenv.isDarwin then "darwin" else "linux";
  mkChannel =
    channel:
    import inputs."nixpkgs-${os}-${channel}" {
      system = final.pkgs.system;
      config = import ../nixpkgs-config.nix;
    };
  useChannel = channel: names: prev.lib.genAttrs names (name: final.${channel}.${name});
  stablePkgs = [ ];
  unstablePkgs = [ ];
in
(prev.lib.genAttrs [
  "stable"
  "unstable"
] mkChannel)
// (useChannel "stable" stablePkgs)
// (useChannel "unstable" unstablePkgs)
