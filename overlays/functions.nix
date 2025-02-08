{ ... }:
final: prev: {
  mkApp = final.callPackage ./functions/make-app.nix { };
  mkDocker = final.callPackage ./functions/make-docker.nix { };
}
