{
  inputs,
  specialModuleArgs,
  moduleArgs,
  lib',
  self,
  lib,
  ...
}:
let
  mkNixvim =
    {
      system,
      extraModule ? { },
    }:
    let
      os = lib'.self.systemOs system;
    in
    inputs.nixvim.lib.evalNixvim {
      extraSpecialArgs = specialModuleArgs // {
        inherit os;
      };
      modules = [
        self.nixvimModules.default
        extraModule
        {
          _module.args = moduleArgs;
          nixpkgs = {
            hostPlatform = system;
            config = self.nixpkgsConfig;
            overlays = [ self.overlays.default ];
            source = lib'.self.systemInput {
              inherit inputs os;
              channel = "unstable";
              name = "nixpkgs";
            };
          };
        }
      ];
    };
in
{
  imports = [ inputs.nixvim.flakeModules.default ];
  nixvim = {
    packages = {
      enable = true;
      nameFunction = name: "nixvim-${name}";
    };
    checks = {
      enable = false;
      nameFunction = name: "nixvim-${name}";
    };
  };
  flake.nixvimModules.default = ../vim;
  perSystem =
    {
      system,
      pkgs,
      config,
      ...
    }:
    {
      packages = {
        neovim = pkgs.nixvim-full;
        neovide = pkgs.writeShellApplication {
          name = "neovide";
          text = ''
            ${lib.getExe pkgs.neovide} --neovim-bin ${lib.getExe config.packages.neovim} "$@"
          '';
        };
      };
      nixvimConfigurations = {
        full = mkNixvim {
          inherit system;
          extraModule = {
            custom.enableOptionalPlugins = true;
          };
        };
        minimal = mkNixvim {
          inherit system;
          extraModule = {
            custom.enableOptionalPlugins = false;
          };
        };
      };
    };
}
