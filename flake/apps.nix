{ lib, self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      apps = {
        default.program = pkgs.writeShellScriptBin "builder" /* bash */ ''
          exec ${lib.getExe pkgs.config-builder} --flake "${self.outPath}" "$@"
        '';
        updater.program = pkgs.writeShellScriptBin "updater" /* bash */ ''
          ${lib.getExe pkgs.flake-updater} --commit
          ${lib.getExe pkgs.pkgs-updater} --commit
        '';
        home-manager.program = pkgs.writeShellScriptBin "home-manager" /* bash */ ''
          exec ${lib.getExe pkgs.home-manager} --flake "${self.outPath}" "$@"
        '';
      }
      // lib.optionalAttrs pkgs.stdenv.isLinux {
        disko.program = pkgs.writeShellScriptBin "disko" /* bash */ ''
          name="$1"
          shift
          exec ${lib.getExe pkgs.disko} --flake "${self.outPath}#$name" "$@"
        '';
        disko-install.program = pkgs.writeShellScriptBin "disko-install" /* bash */ ''
          name="$1"
          shift
          exec ${lib.getExe pkgs.disko-install} --flake "${self.outPath}#$name" "$@"
        '';
        nixos-install.program = pkgs.writeShellScriptBin "nixos-install" /* bash */ ''
          name="$1"
          shift
          exec ${lib.getExe pkgs.nixos-install} --flake "${self.outPath}#$name" --no-channel-copy --no-root-password "$@"
        '';
      };
    };
}
