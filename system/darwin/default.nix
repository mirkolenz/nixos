{
  lib',
  pkgs,
  stateVersions,
  ...
}:
{
  imports = [ ../common ] ++ (lib'.flocken.getModules ./.);

  environment.systemPackages = with pkgs; [ _1password-cli ];

  system.stateVersion = stateVersions.darwin;
}
