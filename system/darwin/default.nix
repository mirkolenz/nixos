{
  lib',
  pkgs,
  stateVersionDarwin,
  ...
}:
{
  imports = [ ../common ] ++ (lib'.flocken.getModules ./.);

  environment.loginShell = pkgs.fish;
  services.nix-daemon.enable = true;

  nix = {
    # settings= {
    #   bash-prompt-prefix = (nix:$name)\040
    #   upgrade-nix-store-path-url = "https://install.determinate.systems/nix-upgrade/stable/universal";
    # };
    settings = {
      build-users-group = "nixbld";
    };
    gc.interval = {
      Hour = 1;
      Minute = 0;
    };
  };

  environment.systemPackages = with pkgs; [ _1password ];

  system.checks.verifyBuildUsers = false;
  system.stateVersion = stateVersionDarwin;
}
