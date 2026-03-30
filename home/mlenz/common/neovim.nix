{
  config,
  lib,
  self,
  ...
}:
{
  # Nixvim's HM module defines programs.nixvim as a submoduleWith type:
  # 1. nixvim wraps extendModules result: https://github.com/nix-community/nixvim/blob/21ae25e13b01d3b4cdc750b5f9e7bad68b150c10/wrappers/_shared.nix#L46-L51
  # 2. extendModules returns .type as submoduleWith: https://github.com/NixOS/nixpkgs/blob/ae67888ff7ef9dff69b3cf0cc0fbfbcd3a722abe/lib/modules.nix#L396-L398
  # 3. submoduleWith.binOp merges specialArgs: https://github.com/NixOS/nixpkgs/blob/ae67888ff7ef9dff69b3cf0cc0fbfbcd3a722abe/lib/types.nix#L1358-L1378
  # We declare a matching submoduleWith to merge our specialArgs into the nixvim submodule.
  options.programs.nixvim = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [ ];
      specialArgs = self.specialModuleArgs;
    };
  };
  config = {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      nixpkgs.useGlobalPackages = true;
      imports = [ self.nixvimModules.default ];
      custom.features = {
        inherit (config.custom.features) withOptionals;
      };
    };
    programs.neovide = lib.mkIf config.custom.features.withDisplay {
      enable = true;
      settings = {
        fork = true;
        neovim-bin = lib.getExe config.programs.nixvim.build.package;
        no-multigrid = true;
      };
    };
  };
}
