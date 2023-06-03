{
  pkgs,
  lib,
  flakeInputs,
  ...
}: {
  nixpkgs.overlays = let
    inherit (pkgs) system;
    inherit (flakeInputs.poetry2nix.legacyPackages.${system}) mkPoetryApplication;
  in [
    flakeInputs.nixneovim.overlays.default
    (_:_: {
      bibtex2cff = mkPoetryApplication {
        projectDir = builtins.toString flakeInputs.bibtex2cff;
        preferWheels = true;
        python = pkgs.python3;
      };
      bibtex-to-cff = with pkgs;
        writeShellScriptBin "bibtex-to-cff" ''
          exec ${lib.getExe php} ${flakeInputs.bibtexbrowser}/bibtex-to-cff.php "$@"
        '';
    })
  ];
}
