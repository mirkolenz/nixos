{
  inputs,
  self,
  ...
}:
final: prev:
let
  inherit (prev.stdenv.hostPlatform) system;
  fromInput =
    input: package:
    if (inputs.${input}.packages ? ${system}) then
      inputs.${input}.packages.${system}.${package}
    else
      null;
in
{
  inherit (self.packages.${system})
    nixvim-full
    nixvim-minimal
    treefmt-nix
    ;
  angrr = fromInput "angrr" "angrr";
  arguebuf = fromInput "arguebuf" "default";
  cosmic-manager = fromInput "cosmic-manager" "cosmic-manager";
  nix-converter = fromInput "nix-converter" "default";
  nix-sweep = fromInput "nix-sweep" "default";
  uv-bin = fromInput "uv2nix" "uv-bin";
  determinate-nix = inputs.determinate.inputs.nix.packages."${system}".default;
}
