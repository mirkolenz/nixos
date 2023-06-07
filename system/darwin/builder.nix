# https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder
{
  pkgs,
  flakeInputs,
  ...
}: let
  inherit (pkgs) system;
  inherit (flakeInputs) nixpkgs;
  linuxSystem = builtins.replaceStrings ["darwin"] ["linux"] system;
  darwin-builder = nixpkgs.lib.nixosSystem {
    system = linuxSystem;
    modules = [
      "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
      {
        system.nixos.revision = nixpkgs.lib.mkForce null;
        virtualisation = {
          host = {
            pkgs = nixpkgs.legacyPackages.${system};
          };
          # darwin-builder = {
          #   diskSize = 5120;
          #   memorySize = 1024;
          #   hostPort = 33022;
          #   workingDirectory = "/var/lib/darwin-builder";
          # };
        };
      }
    ];
  };
in {
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "ssh://builder@localhost";
        system = linuxSystem;
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
      }
    ];
    settings = {
      builders-use-substitutes = true;
    };
  };
  launchd.daemons.darwin-builder = {
    command = "${darwin-builder.config.system.build.macos-builder-installer}/bin/create-builder";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/darwin-builder.log";
      StandardErrorPath = "/var/log/darwin-builder.log";
    };
  };
}
