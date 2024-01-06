{
  inputs,
  moduleArgs,
  specialArgs,
  self,
  lib,
  lib',
  ...
}: let
  mkHomeConfig = userName: {
    channel,
    system,
  }: let
    os = lib'.self.getOs system;
    hmInput = inputs."home-manager-${os}-${channel}";
  in
    hmInput.lib.homeManagerConfiguration {
      pkgs = import hmInput.inputs.nixpkgs {
        inherit system;
      };
      extraSpecialArgs = specialArgs;
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
