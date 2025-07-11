args: final: prev:
prev.lib.mergeAttrsList [
  (args.inputs.nix-darwin-unstable.overlays.default final prev)
  (import ./by-name.nix args final prev)
  (import ./channels.nix args final prev)
  (import ./imports.nix args final prev)
  (import ./overrides.nix args final prev)
]
