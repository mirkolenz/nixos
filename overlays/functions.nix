{ ... }:
final: prev:
let
  exportedFunctions = {
    mkApp = final.callPackage ./functions/make-app.nix { };
    mkBuilder = final.callPackage ./functions/make-builder.nix { };
    mkDocker = final.callPackage ./functions/make-docker.nix { };
  };
in
{
  exported-functions = exportedFunctions;
}
// exportedFunctions
