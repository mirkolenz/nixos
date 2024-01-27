{
  self,
  lib,
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      system,
      config,
      ...
    }:
    let
      systemBuilder =
        if pkgs.stdenv.isDarwin then
          lib.getExe' inputs.nix-darwin-unstable.packages.${system}.default "darwin-rebuild"
        else
          lib.getExe pkgs.nixos-rebuild;
      homeBuilder =
        lib.getExe' inputs.home-manager-linux-unstable.packages.${system}.default
          "home-manager";
    in
    {
      packages = {
        default = config.packages.system;
        system = config.legacyPackages.mkBuilder { exe = systemBuilder; };
        home = config.legacyPackages.mkBuilder { exe = homeBuilder; };
        builder-wrapper =
          pkgs.writers.writePython3Bin "builder-wrapper"
            {
              libraries = with pkgs.python3Packages; [ typer ];
              flakeIgnore = [
                "E203"
                "E501"
              ];
            }
            (builtins.readFile ./builder-wrapper.py);
      };
      legacyPackages.mkBuilder =
        {
          exe,
          flake ? self,
          args ? [ ],
        }:
        pkgs.writeShellApplication {
          name = "builder";
          text = ''
            exec ${lib.getExe config.packages.builder-wrapper} ${exe} --flake ${self.outPath} ${lib.escapeShellArgs args} "$@"
          '';
        };
    };
}
