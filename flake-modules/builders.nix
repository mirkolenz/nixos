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
    wrapper =
      pkgs.writers.writePython3Bin "builder-wrapper" {
        libraries = with pkgs.python3Packages; [typer];
        flakeIgnore = ["E203" "E501"];
      }
      (builtins.readFile ./builder.py);
    mkBuilder = builderExe:
      pkgs.writeShellApplication {
        name = "builder";
        text = ''
          exec ${lib.getExe wrapper} ${builderExe} --flake ${self.outPath} "$@"
        '';
      };
    systemBuilder =
      if pkgs.stdenv.isDarwin
      then lib.getExe' inputs.nix-darwin-unstable.packages.${system}.default "darwin-rebuild"
      else lib.getExe pkgs.nixos-rebuild;
    homeBuilder = lib.getExe' inputs.home-manager-linux-unstable.packages.${system}.default "home-manager";
  in {
    packages = {
      default = config.packages.system;
      system = mkBuilder systemBuilder;
      home = mkBuilder homeBuilder;
    };
  };
}
