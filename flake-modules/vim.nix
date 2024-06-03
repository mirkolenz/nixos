{
  inputs,
  specialModuleArgs,
  moduleArgs,
  lib',
  ...
}:
{
  perSystem =
    {
      pkgs,
      system,
      config,
      ...
    }:
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
      # https://github.com/nix-community/nixvim/issues/1154
      # https://github.com/nix-community/nixvim/issues/1525
      # checks = {
      #   inherit (config.packages) vim;
      # };
      packages = {
        vim = config.packages.vim-unstable;
        vim-unstable = mkVim "unstable";
        # Currently broken, see https://github.com/nix-community/nixvim/pull/914
        # vim-stable = mkVim "stable";
      };
    };
}
