{
  mylib,
  pkgs,
  stateVersionDarwin,
  ...
}: {
  imports = [../common] ++ (mylib.importFolder ./.);

  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;

  nix = {
    linux-builder.enable = true;
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
