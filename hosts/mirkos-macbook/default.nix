{ ... }:
{
  imports = [
    ../../templates/mac.nix
  ];

  networking = {
    computerName = "Mirkos MacBook";
    hostName = "mirkos-macbook";
  };
}
