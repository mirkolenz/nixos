args@{ inputs, ... }:
[
  (
    final: prev:
    prev.lib.mergeAttrsList (
      (map (name: import name args final prev) [
        ./channels.nix
        ./functions.nix
        ./overrides.nix
        ./packages.nix
        ./vim-plugins.nix
      ])
      ++ (map (name: name final prev) [
        inputs.nix-darwin-unstable.overlays.default
      ])
    )
  )
]
