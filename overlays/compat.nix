final: prev:
let
  useChannel = channel: names: prev.lib.genAttrs names (name: final.${channel}.${name});
  stablePkgs = [ "nvfetcher" ];
  unstablePkgs = [ ];
in
(useChannel "stable" stablePkgs) // (useChannel "unstable" unstablePkgs)
