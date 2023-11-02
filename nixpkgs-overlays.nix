inputs: [
  inputs.nixneovim.overlays.default
  inputs.poetry2nix.overlays.default
  (import ./overlays inputs)
]
