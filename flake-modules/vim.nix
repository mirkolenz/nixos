{
  inputs,
  specialModuleArgs,
  moduleArgs,
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
        extraSpecialArgs = specialModuleArgs;
        module = {
          imports = [../vim];
          _module.args = moduleArgs;
        };
      };
  in {
    packages = {
      vim = mkVim inputs.nixvim-unstable;
      # Currently broken, see https://github.com/nix-community/nixvim/pull/914
      # vim-stable = mkVim inputs.nixvim-linux-stable;
    };
  };
}
