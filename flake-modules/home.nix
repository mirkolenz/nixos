{
  inputs,
  moduleArgs,
  specialModuleArgs,
  self,
  lib,
  lib',
  ...
}:
let
  mkHomeConfig =
    name:
    {
      channel,
      system,
      extraModule ? { },
    }:
    let
      login = lib.head (lib.splitString "@" name);
      os = lib'.self.systemOs system;
      homeManager = lib'.self.systemInput {
        inherit inputs channel os;
        name = "home-manager";
      };
    in
    homeManager.lib.homeManagerConfiguration {
      pkgs = import homeManager.inputs.nixpkgs { inherit system; };
      extraSpecialArgs = specialModuleArgs // {
        inherit channel os;
      };
      modules = [
        extraModule
        self.configModules.home
        { _module.args.user = lib.mkForce (moduleArgs.user // { inherit login; }); }
      ];
    };
in
{
  flake.homeConfigurations = lib.mapAttrs mkHomeConfig {
    "lenz@gpu.wi2.uni-trier.de" = {
      channel = "unstable";
      system = "x86_64-linux";
    };
  };
}
