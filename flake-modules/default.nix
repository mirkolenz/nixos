{
  lib',
  inputs,
  self,
  lib,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;
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
        ci = lib.mapAttrs (name: value: value.outPath) (
          lib.filterAttrs (
            name: value: lib.elem system (value.meta.hydraPlatforms or [ system ]) && name != "default"
          ) config.packages
        );
      };
      packages =
        (lib.filterAttrs (
          name: value: lib.meta.availableOn { inherit system; } value && !(value.meta.broken or false)
        ) pkgs.drvsExport)
        // {
          default = pkgs.writeShellScriptBin "config-builder" ''
            exec ${lib.getExe pkgs.config-builder} --flake ${self.outPath} "$@"
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
