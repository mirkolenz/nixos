{
  inputs,
  specialModuleArgs,
  moduleArgs,
  lib',
  ...
}:
{
  perSystem =
    { system, config, ... }:
    let
      os = lib'.self.systemOs system;
      mkVim =
        channel:
        let
          nixvim = lib'.self.systemInput {
            inherit inputs channel os;
            name = "nixvim";
          };
        in
        nixvim.legacyPackages.${system}.makeNixvimWithModule {
          pkgs = import nixvim.inputs.nixpkgs {
            inherit system;
            config = import ../nixpkgs-config.nix;
            overlays = import ../overlays specialModuleArgs;
          };
          extraSpecialArgs = specialModuleArgs // {
            inherit channel os;
          };
          module = {
            imports = [ ../vim ];
            _module.args = moduleArgs;
          };
        };
    in
    {
      packages = {
        vim = config.packages.vim-unstable;
        vim-unstable = mkVim "unstable";
        vim-stable = mkVim "stable";
      };
    };
}
