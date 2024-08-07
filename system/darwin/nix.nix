{
  nix = {
    # settings= {
    #   bash-prompt-prefix = (nix:$name)\040
    #   upgrade-nix-store-path-url = "https://install.determinate.systems/nix-upgrade/stable/universal";
    # };
    settings = {
      build-users-group = "nixbld";
      allowed-users = [ "@staff" ];
    };
    gc.interval = {
      Hour = 1;
      Minute = 0;
    };
  };
  services.nix-daemon.enable = true;
}
