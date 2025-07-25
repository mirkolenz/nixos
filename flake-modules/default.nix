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
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = self.nixpkgsConfig;
        overlays = [ self.overlays.default ];
      };
      legacyPackages = pkgs;
      packages = pkgs.custom-packages // {
        default = pkgs.writeShellScriptBin "default" ''
          exec ${lib.getExe pkgs.builder} --flake ${self.outPath} "$@"
        '';
      };
    };
  flake = {
    lib = lib'.self;
    overlays.default = import ../overlay self.overlayArgs;
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
