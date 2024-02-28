inputs: [
  (import ./apps)
  (import ./channels.nix inputs)
  (import ./compat.nix)
  (import ./packages inputs)
  inputs.poetry2nix.overlays.default
]
