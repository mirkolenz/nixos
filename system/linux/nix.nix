{
  nix = {
    settings = {
      # https://github.com/NixOS/nix/issues/7273#issuecomment-1310213986
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
      sandbox = true;
    };
    gc.dates = "daily";
  };
}
