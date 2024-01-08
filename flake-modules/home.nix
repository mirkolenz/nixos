{
  inputs,
  moduleArgs,
  specialModuleArgs,
  self,
  lib,
  lib',
  ...
}: let
  mkHomeConfig = name: {
    channel,
    system,
  }: let
    login = builtins.head (lib.splitString "@" name);
    os = lib'.self.systemOs system;
    hmInput = inputs."home-manager-${os}-${channel}";
  in
    hmInput.lib.homeManagerConfiguration {
      pkgs = import hmInput.inputs.nixpkgs {
        inherit system;
      };
      extraSpecialArgs = specialModuleArgs;
      modules = [
        self.configModules.home
        {
          _module.args.user = lib.mkForce (
            moduleArgs.user // {inherit login;}
          );
        }
      ];
    };
in {
  flake.homeConfigurations = builtins.mapAttrs mkHomeConfig {
    "lenz@gpu.wi2.uni-trier.de" = {
      channel = "unstable";
      system = "x86_64-linux";
    };
  };
}
