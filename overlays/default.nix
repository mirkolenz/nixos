inputs: [
  (import ./apps)
  (import ./channels.nix inputs)
  (import ./packages inputs)
  inputs.poetry2nix.overlays.default
]
