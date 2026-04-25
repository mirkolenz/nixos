{
  lib',
  inputs,
  self,
  lib,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  debug = true;
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];

  perSystem =
    {
      pkgs,
      system,
      config,
      ...
    }:
    let
      drvsSelf = {
        default = pkgs.writeShellScriptBin "builder" /* bash */ ''
          exec ${lib.getExe pkgs.config-builder} --flake "${self.outPath}" "$@"
        '';
        updater = pkgs.writeShellScriptBin "updater" /* bash */ ''
          ${lib.getExe pkgs.flake-updater} --commit
          ${lib.getExe pkgs.pkgs-updater} --commit
        '';
        home-manager = pkgs.writeShellScriptBin "home-manager" /* bash */ ''
          exec ${lib.getExe pkgs.home-manager} --flake "${self.outPath}" "$@"
        '';
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        mirkos-macbook-rsync = pkgs.callPackage ../pkgs/derivations/mirkos-macbook-rsync.nix {
          darwinConfig = self.darwinConfigurations.mirkos-macbook;
        };
      }
      // lib.optionalAttrs pkgs.stdenv.isLinux {
        disko = pkgs.writeShellScriptBin "disko" /* bash */ ''
          name="$1"
          shift
          exec ${lib.getExe pkgs.disko} --flake "${self.outPath}#$name" "$@"
        '';
        disko-install = pkgs.writeShellScriptBin "disko-install" /* bash */ ''
          name="$1"
          shift
          exec ${lib.getExe pkgs.disko-install} --flake "${self.outPath}#$name" "$@"
        '';
        nixos-install = pkgs.writeShellScriptBin "nixos-install" /* bash */ ''
          name="$1"
          shift
          exec ${lib.getExe pkgs.nixos-install} --flake "${self.outPath}#$name" --no-channel-copy --no-root-password "$@"
        '';
      };
    in
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = self.nixpkgsConfig;
        overlays = [ self.overlays.default ];
      };
      legacyPackages.drvsCi = lib.mapAttrs (name: value: value.outPath) (
        lib.filterAttrs (
          name: value:
          lib.elem system (value.meta.hydraPlatforms or [ system ])
          && !(lib.elem name (lib.attrNames drvsSelf))
        ) config.packages
      );
      checks = lib.filterAttrs (
        name: value:
        lib.elem system (value.meta.hydraPlatforms or [ system ])
        && !(lib.elem name (lib.attrNames drvsSelf))
      ) config.packages;
      packages =
        (lib.filterAttrs (
          name: value: lib.meta.availableOn { inherit system; } value && !(value.meta.broken or false)
        ) pkgs.drvsExport)
        // drvsSelf;
    };
  flake = {
    lib = lib';
    overlays.default =
      final: prev: if prev == { } then { } else import ../pkgs self.overlayArgs final prev;
    nixpkgsConfig = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
    overlayArgs = {
      inherit
        self
        inputs
        lib'
        ;
    };
  };
}
