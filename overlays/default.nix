{
  pkgs,
  lib,
  flakeInputs,
  ...
}: let
  inherit (pkgs) system;
  getPkg = input: name: flakeInputs.${input}.packages.${system}.${name};
in {
  nixpkgs.overlays = [
    flakeInputs.nixneovim.overlays.default
    (final: prev: {
      bibtex2cff = pkgs.poetry2nix.mkPoetryApplication {
        projectDir = builtins.toString flakeInputs.bibtex2cff;
        preferWheels = true;
        python = pkgs.python3;
      };
      bibtex-to-cff = with pkgs;
        writeShellApplication {
          name = "bibtex-to-cff";
          text = ''
            exec ${lib.getExe php} ${flakeInputs.bibtexbrowser}/bibtex-to-cff.php "$@"
          '';
        };
      makejinja = getPkg "makejinja" "default";
      arguebuf = getPkg "arguebuf" "default";
    })
  ];
}
