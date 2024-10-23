{ ... }:
{
  # https://github.com/LnL7/nix-darwin/blob/master/modules/nix/linux-builder.nix
  # The ServerAliveInterval and IPQoS settings have been found to make remote builds more reliable,
  # especially if there are long silent periods with no logs emitted by a build.
  imports = [ ./orbstack.nix ];
  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
  };
}
