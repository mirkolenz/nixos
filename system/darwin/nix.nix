{
  nix = {
    settings = {
      build-users-group = "nixbld";
      allowed-users = [ "@staff" ];
      # upgrade-nix-store-path-url = "https://install.determinate.systems/nix-upgrade/stable/universal";
    };
    gc.interval = {
      Hour = 1;
      Minute = 0;
    };
  };
  services.nix-daemon.enable = true;
}
