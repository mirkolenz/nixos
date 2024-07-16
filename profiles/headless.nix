{ lib, ... }:
{
  services.openssh.enable = lib.mkDefault true;
  environment.variables.BROWSER = "echo";
}
