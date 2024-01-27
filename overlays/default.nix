inputs: [
  (import ./apps)
  (import ./channels.nix inputs)
  (import ./compat.nix)
  (import ./packages.nix inputs)
  inputs.poetry2nix.overlays.default
]
