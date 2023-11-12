inputs: [
  inputs.nixneovim.overlays.default
  inputs.poetry2nix.overlays.default
  (import ./channels.nix inputs)
  (import ./packages.nix inputs)
]
