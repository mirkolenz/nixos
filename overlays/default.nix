args@{ inputs, ... }:
[
  (
    final: prev:
    prev.lib.mergeAttrsList (
      (map (name: import name args final prev) [
        ./channels.nix
        ./overrides.nix
        ./functions.nix
        ./packages.nix
      ])
      ++ (map (name: name final prev) [
        inputs.nix-darwin-unstable.overlays.default
      ])
    )
  )
]
