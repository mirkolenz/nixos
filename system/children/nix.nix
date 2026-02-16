{
  ...
}:
{
  nix = {
    settings = {
      allowed-users = [ "@wheel" ];
      sandbox = true;
    };
    channel.enable = false;
  };
}
