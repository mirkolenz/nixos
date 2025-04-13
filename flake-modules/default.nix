{
  lib',
  inputs,
  nixpkgsArgs,
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
        inherit (nixpkgsArgs) config overlays;
      };
      legacyPackages = pkgs;
      packages = pkgs.exported-packages // {
        default = pkgs.mkBuilder { flake = self; };
      };
    };
  flake = {
    lib = lib'.self;
  };
}
