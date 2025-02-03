{
  lib,
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      packages = {
        builder = config.legacyPackages.mkBuilder { };
        builder-wrapper = pkgs.writers.writePython3Bin "builder-wrapper" {
          libraries = with pkgs.python3Packages; [ typer ];
          flakeIgnore = [
            "E203"
            "E501"
          ];
        } (lib.readFile ./builder-wrapper.py);
      };
      legacyPackages.mkBuilder =
        {
          flake ? self,
          args ? [ ],
        }:
        pkgs.writeShellApplication {
          name = "builder";
          text = ''
            exec ${lib.getExe config.packages.builder-wrapper} \
              --darwin-builder ${lib.getExe pkgs.darwin-rebuild} \
              --linux-builder ${lib.getExe pkgs.nixos-rebuild} \
              --home-builder ${lib.getExe pkgs.home-manager} \
              --flake ${flake} \
              ${lib.escapeShellArgs args} \
              "$@"
          '';
        };
    };
}
