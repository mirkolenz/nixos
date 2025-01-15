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
      login = builtins.head (lib.splitString "@" name);
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
  flake.homeConfigurations = builtins.mapAttrs mkHomeConfig {
    intel-linux = {
      channel = "unstable";
      system = "x86_64-linux";
    };
    arm-linux = {
      channel = "unstable";
      system = "aarch64-linux";
    };
    "lenz@gpu.wi2.uni-trier.de" = {
      channel = "unstable";
      system = "x86_64-linux";
    };
  };
}
