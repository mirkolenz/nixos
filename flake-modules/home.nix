{
  inputs,
  moduleArgs,
  specialModuleArgs,
  self,
  lib,
  lib',
  ...
}: let
  mkHomeConfig = userName: {
    channel,
    system,
  }: let
    os = lib'.self.systemOs system;
    hmInput = inputs."home-manager-${os}-${channel}";
  in
    hmInput.lib.homeManagerConfiguration {
      pkgs = import hmInput.inputs.nixpkgs {
        inherit system;
      };
      extraSpecialArgs = specialModuleArgs;
      modules = [
        self.configModules.homeManager
        self.configModules.home
        {
          _module.args.user = lib.mkForce (
            moduleArgs.user
            // {
              login = userName;
            }
          );
        }
      ];
    };

  mkDefaultHomeConfig = system: userName:
    mkHomeConfig userName {
      inherit system;
      channel = "unstable";
    };
in {
  perSystem = {system, ...}: {
    legacyPackages.homeConfigurations =
      lib.genAttrs
      ["mlenz" "lenz" "mirkolenz" "mirkol"]
      (mkDefaultHomeConfig system);
  };
}
