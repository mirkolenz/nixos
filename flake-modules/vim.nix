{
  inputs,
  specialArgs,
  moduleArgs,
  lib',
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    mkVim = input:
      input.legacyPackages.${system}.makeNixvimWithModule {
        pkgs = import input.inputs.nixpkgs {
          inherit system;
          config = import ../nixpkgs-config.nix;
        };
        extraSpecialArgs = specialArgs;
        module = {
          imports = [
            (import ../vim lib')
          ];
          _module.args = moduleArgs;
        };
      };
  in {
    packages = {
      vim = mkVim inputs.nixvim-unstable;
      vim-stable = mkVim inputs.nixvim-linux-stable;
    };
  };
}
