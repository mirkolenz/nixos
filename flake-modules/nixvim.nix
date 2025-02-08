{
  inputs,
  specialModuleArgs,
  moduleArgs,
  nixpkgsArgs,
  lib',
  ...
}:
{
  perSystem =
    { system, config, ... }:
    {
      packages = {
        nixvim = config.packages.nixvim-unstable;
        nixvim-unstable = config.legacyPackages.mkNixvim "unstable";
        nixvim-stable = config.legacyPackages.mkNixvim "stable";
      };
      legacyPackages.mkNixvim =
        channel:
        let
          os = lib'.self.systemOs system;
          nixvim = lib'.self.systemInput {
            inherit inputs channel os;
            name = "nixvim";
          };
        in
        nixvim.legacyPackages.${system}.makeNixvimWithModule {
          pkgs = import nixvim.inputs.nixpkgs {
            inherit system;
            inherit (nixpkgsArgs) config overlays;
          };
          extraSpecialArgs = specialModuleArgs // {
            inherit channel os;
          };
          module = {
            imports = [ ../vim ];
            _module.args = moduleArgs;
          };
        };
    };
}
