inputs: (final: prev: let
  inherit (final) system;
  getPkg = input: inputs.${input}.packages.${system}.default;
  lib = final.lib;
in {
  bibtex2cff = final.poetry2nix.mkPoetryApplication {
    projectDir = builtins.toString inputs.bibtex2cff;
    preferWheels = true;
    python = final.python3;
  };
  bibtex-to-cff = final.writeShellApplication {
    name = "bibtex-to-cff";
    text = ''
      exec ${lib.getExe final.php} ${inputs.bibtexbrowser}/bibtex-to-cff.php "$@"
    '';
  };
  makejinja = getPkg "makejinja";
  arguebuf = getPkg "arguebuf";
  dummy = final.writeShellScriptBin "dummy" ":";
})