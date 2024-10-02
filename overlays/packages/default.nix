{ inputs, ... }:
final: prev:
let
  inherit (final) system;
  getPkg = input: inputs.${input}.packages.${system}.default;
in
{
  arguebuf = getPkg "arguebuf";
  nixfmt = final.nixfmt-rfc-style;
  dummy = final.writeShellScriptBin "dummy" ":";
  bibtex2cff = final.callPackage ./bibtex2cff.nix { };
  bibtexbrowser2cff = final.callPackage ./bibtexbrowser2cff.nix { };
}
