{
  pkgs,
  lib,
  flakeInputs,
  ...
}: let
  inherit (pkgs) system;
  inherit (flakeInputs.poetry2nix.legacyPackages.${system}) mkPoetryApplication;
in {
  nixpkgs.overlays = [
    flakeInputs.nixneovim.overlays.default
    flakeInputs.nixd.overlays.default
    (self: super: {
      bibtex2cff = mkPoetryApplication {
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
      makejinja = flakeInputs.makejinja.packages.${system}.default;
      arguebuf = flakeInputs.arguebuf.packages.${system}.default;
    })
  ];
}
