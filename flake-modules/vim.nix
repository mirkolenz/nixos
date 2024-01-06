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
        module = import ../vim {
          inherit lib' specialArgs moduleArgs;
        };
      };
  in {
    packages = {
      vim = mkVim inputs.nixvim-unstable;
      vim-stable = mkVim inputs.nixvim-linux-stable;
    };
  };
}
