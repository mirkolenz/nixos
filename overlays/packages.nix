inputs:
(
  final: prev:
  let
    inherit (final) system;
    getPkg = input: inputs.${input}.packages.${system}.default;
    lib = final.lib;
  in
  {
    bibtex2cff = final.poetry2nix.mkPoetryApplication {
      projectDir = toString inputs.bibtex2cff;
      preferWheels = true;
      python = final.python3;
    };
    bibtexbrowser2cff = final.writeShellApplication {
      name = "bibtexbrowser2cff";
      text = ''
        exec ${lib.getExe final.php} ${inputs.bibtexbrowser}/bibtex-to-cff.php "$@"
      '';
    };
    makejinja = getPkg "makejinja";
    arguebuf = getPkg "arguebuf";
    dummy = final.writeShellScriptBin "dummy" ":";
    nixfmt = final.unstable.nixfmt-rfc-style;
  }
)
