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
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = self.nixpkgsConfig;
        overlays = [ self.overlays.default ];
      };
      legacyPackages = pkgs // {
        drvsCi = lib.mapAttrs (name: value: value.outPath) (
          lib.filterAttrs (
            name: value:
            lib.elem system (value.meta.hydraPlatforms or [ system ])
            && !(lib.elem name [
              "default"
              "updater"
            ])
          ) config.packages
        );
      };
      packages =
        (lib.filterAttrs (
          name: value: lib.meta.availableOn { inherit system; } value && !(value.meta.broken or false)
        ) pkgs.drvsExport)
        // {
          default = pkgs.writeShellScriptBin "builder" /* bash */ ''
            exec ${lib.getExe pkgs.config-builder} --flake ${self.outPath} "$@"
          '';
          updater = pkgs.writeShellScriptBin "updater" /* bash */ ''
            ${lib.getExe pkgs.flake-updater} --commit
            ${lib.getExe pkgs.pkgs-updater} --commit
          '';
        };
    };
  flake = {
    lib = lib';
    overlays.default = import ../pkgs self.overlayArgs;
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
