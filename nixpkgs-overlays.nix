inputs: [
  inputs.nixneovim.overlays.default
  inputs.poetry2nix.overlay
  (import ./overlays inputs)
]
