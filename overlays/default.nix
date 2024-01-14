inputs: [
  (import ./apps.nix)
  (import ./channels.nix inputs)
  (import ./compat.nix)
  (import ./packages.nix inputs)
  inputs.poetry2nix.overlays.default
]
