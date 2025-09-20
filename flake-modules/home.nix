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
      system,
      extraModule ? { },
    }:
    let
      login = lib.head (lib.splitString "@" name);
      os = lib'.self.systemOs system;
      nixpkgs = lib'.self.systemInput {
        inherit inputs os;
        channel = "unstable";
        name = "nixpkgs";
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      extraSpecialArgs = specialModuleArgs // {
        inherit os;
        osConfig = { };
      };
      modules = [
        extraModule
        self.homeModules."${os}-standalone"
        { _module.args.user = lib.mkForce (moduleArgs.user // { inherit login; }); }
      ];
    };
in
{
  imports = [ inputs.home-manager.flakeModules.default ];
  flake.homeConfigurations = lib.mapAttrs mkHomeConfig {
    "lenz@gpu.wi2.uni-trier.de" = {
      system = "x86_64-linux";
    };
    "eifelkreis@vserv-4514" = {
      system = "x86_64-linux";
    };
    "compute@kitei-gpu" = {
      system = "x86_64-linux";
    };
  };
  perSystem =
    { ... }:
    {
      packages = lib.mapAttrs' (name: module: {
        name = "home-config-${name}";
        value = module.activationPackage;
      }) self.homeConfigurations;
    };
}
