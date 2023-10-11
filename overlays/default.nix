inputs: (final: prev: let
  inherit (final.pkgs) system;
  getPkg = input: inputs.${input}.packages.${system}.default;
  pkgs = final.pkgs;
  lib = final.lib;
in {
  bibtex2cff = pkgs.poetry2nix.mkPoetryApplication {
    projectDir = builtins.toString inputs.bibtex2cff;
    preferWheels = true;
    python = pkgs.python3;
  };
  bibtex-to-cff = with pkgs;
    writeShellApplication {
      name = "bibtex-to-cff";
      text = ''
        exec ${lib.getExe php} ${inputs.bibtexbrowser}/bibtex-to-cff.php "$@"
      '';
    };
  makejinja = getPkg "makejinja";
  arguebuf = getPkg "arguebuf";
})
