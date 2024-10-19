{ inputs, ... }@args:
final: prev:
let
  customPackages = {
    common = import ./common args final prev;
    darwin = import ./darwin args final prev;
    linux = { };
  };
  inherit (final) system;
  getPkg = input: inputs.${input}.packages.${system}.default;
in
{
  custom = customPackages;
  arguebuf = getPkg "arguebuf";
  custom-caddy = getPkg "custom-caddy";
  custom-caddy-docker = inputs.custom-caddy.packages.${system}.docker;
  nixfmt = final.nixfmt-rfc-style;
  dummy = final.writeShellScriptBin "dummy" ":";
  mkApp = final.callPackage ./make-app.nix { };
}
// customPackages.common
// customPackages.linux
// customPackages.darwin
