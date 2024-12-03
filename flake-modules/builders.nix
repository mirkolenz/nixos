{ lib, inputs, ... }:
{
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      packages = {
        default = config.packages.system;
        system = config.legacyPackages.mkBuilder {
          exe =
            if pkgs.stdenv.isDarwin then lib.getExe pkgs.darwin-rebuild else lib.getExe pkgs.nixos-rebuild;
          args = if pkgs.stdenv.isDarwin then [ "--pure" ] else [ "--impure" ];
        };
        home = config.legacyPackages.mkBuilder {
          exe = lib.getExe pkgs.home-manager;
          args = [ "--pure" ];
        };
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
