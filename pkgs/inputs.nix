{ inputs, ... }:
final: prev:
let
  inherit (prev.stdenv.hostPlatform) system;
  fromInput = input: package: inputs.${input}.packages.${system}.${package} or final.empty;
in
{
  cosmic-manager = fromInput "cosmic-manager" "cosmic-manager";
  disko = fromInput "disko" "disko";
  disko-install = fromInput "disko" "disko-install";
  mistral-vibe = fromInput "mistral-vibe" "default";
  nix-converter = fromInput "nix-converter" "default";
  nix-sweep = fromInput "nix-sweep" "default";
  opnix = fromInput "opnix" "default";
  zjstatus = fromInput "zjstatus" "default";
}
