{
  self,
  lib',
  pkgs,
  stateVersionDarwin,
  ...
}: {
  imports = [../common] ++ (lib'.flocken.getModules ./.);

  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;

  nix = {
    linux-builder.enable = true;
    nixPath = [
      # "darwin-config=${self.outPath}/flake.nix"
    ];
    settings = {
      build-users-group = "nixbld";
    };
    gc.interval = {
      Hour = 1;
      Minute = 0;
    };
  };

  system.checks.verifyBuildUsers = false;
  system.stateVersion = stateVersionDarwin;
}
