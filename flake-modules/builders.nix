{
  self,
  lib,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    config,
    ...
  }: let
    builderOpts = lib.escapeShellArgs ["--impure" "--no-write-lock-file"];
    mkBuilder = builder:
      pkgs.writeShellApplication {
        name = "builder";
        text = ''
          set -x #echo on
          exec ${lib.getExe builder} --flake "${self.outPath}" ${builderOpts} "''${1:-switch}" "''${@:2}"
        '';
      };
    systemBuilder =
      if pkgs.stdenv.isDarwin
      then inputs.nix-darwin-unstable.packages.${system}.default
      else
        pkgs.writeShellApplication {
          name = "sudo-nixos-rebuild";
          text = ''
            sudo ${lib.getExe pkgs.nixos-rebuild} "$@"
          '';
        };

    homeBuilder = inputs.home-manager-linux-unstable.packages.${system}.default;
  in {
    packages = {
      default = config.packages.system;
      system = mkBuilder systemBuilder;
      home = mkBuilder homeBuilder;
    };
  };
}
