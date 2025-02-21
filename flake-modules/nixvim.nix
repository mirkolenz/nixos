{
  inputs,
  specialModuleArgs,
  moduleArgs,
  nixpkgsArgs,
  lib',
  self,
  lib,
  ...
}:
let
  mkNixvim =
    { channel, system }:
    let
      os = lib'.self.systemOs system;
    in
    inputs.nixvim.lib.evalNixvim {
      extraSpecialArgs = specialModuleArgs // {
        inherit channel os;
      };
      modules = [
        self.nixvimModules.default
        {
          _module.args = moduleArgs;
          nixpkgs = {
            hostPlatform = system;
            inherit (nixpkgsArgs) config overlays;
            source = lib'.self.systemInput {
              inherit inputs channel os;
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
      enable = false; # they are manually added to the github actions matrix
      nameFunction = name: "nixvim-${name}";
    };
  };
  flake.nixvimModules.default = ../vim;
  perSystem =
    { system, pkgs, ... }:
    {
      packages = {
        nvim = pkgs.nixvim;
        neovide = pkgs.writeShellApplication {
          name = "neovide";
          text = ''
            ${lib.getExe pkgs.neovide} --neovim-bin ${lib.getExe pkgs.nixvim} "$@"
          '';
        };
      };
      nixvimConfigurations = lib.genAttrs [ "unstable" ] (channel: mkNixvim { inherit channel system; });
    };
}
