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
      os = lib'.systemOs system;
      nixpkgs = lib'.systemInput {
        inherit os;
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
      extraModule = {
        home.uid = 1002;
        targets.genericLinux.enable = true;
      };
    };
    "eifelkreis@vserv-4514" = {
      system = "x86_64-linux";
      extraModule = {
        home.uid = 1001;
        targets.genericLinux.enable = true;
      };
    };
    "compute@kitei-gpu" = {
      system = "x86_64-linux";
      extraModule = {
        home.uid = 1001;
        targets.genericLinux.enable = true;
      };
    };
    "mlenz@raise" = {
      system = "x86_64-linux";
      extraModule = {
        home.uid = 1000;
        targets.genericLinux.enable = false;
      };
    };
  };
}
