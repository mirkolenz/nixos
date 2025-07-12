{
  lib',
  inputs,
  self,
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
      packages = pkgs.exported-packages // {
        default = pkgs.mkBuilder { flake = self; };
      };
    };
  flake = {
    lib = lib'.self;
    overlays.default = import ../overlays {
      inherit
        self
        inputs
        lib'
        ;
    };
    nixpkgsConfig = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
  };
}
