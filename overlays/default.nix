{
  pkgs,
  flakeInputs,
  ...
}: {
  nixpkgs.overlays = let
    inherit (pkgs) system;
    inherit (flakeInputs.poetry2nix.legacyPackages.${system}) mkPoetryApplication;
  in [
    flakeInputs.nixneovim.overlays.default
    (_:_: {
      nixd = flakeInputs.nixd.packages.${system}.default;
      bibtex2cff = mkPoetryApplication {
        projectDir = builtins.toString flakeInputs.bibtex2cff;
        preferWheels = true;
        python = pkgs.python3;
      };
    })
  ];
}
