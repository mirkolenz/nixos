{
  inputs,
  moduleArgs,
  specialArgs,
  self,
  lib,
  lib',
  moduleWithSystem,
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
  flake.homeConfigurations = moduleWithSystem ({system}:
    lib.genAttrs
    ["mlenz" "lenz" "mirkolenz" "mirkol"]
    (mkDefaultHomeConfig system));
}
