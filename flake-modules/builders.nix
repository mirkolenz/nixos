{ lib, inputs, ... }:
{
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    let
      systemBuilder =
        if pkgs.stdenv.isDarwin then
          lib.getExe' pkgs.darwin-rebuild "darwin-rebuild"
        else
          lib.getExe pkgs.nixos-rebuild;
      homeBuilder = lib.getExe pkgs.home-manager;
    in
    {
      packages = {
        default = config.packages.system;
        system = config.legacyPackages.mkBuilder { exe = systemBuilder; };
        home = config.legacyPackages.mkBuilder { exe = homeBuilder; };
        builder-wrapper = pkgs.writers.writePython3Bin "builder-wrapper" {
          libraries = with pkgs.python3Packages; [ typer ];
          flakeIgnore = [
            "E203"
            "E501"
          ];
        } (builtins.readFile ./builder-wrapper.py);
      };
      legacyPackages.mkBuilder =
        {
          exe,
          flake ? inputs.self,
          args ? [ ],
        }:
        pkgs.writeShellApplication {
          name = "builder";
          text = ''
            exec ${lib.getExe config.packages.builder-wrapper} ${exe} --flake ${flake} ${lib.escapeShellArgs args} "$@"
          '';
        };
    };
}
