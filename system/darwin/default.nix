{
  lib',
  pkgs,
  stateVersionDarwin,
  ...
}:
{
  imports = [ ../common ] ++ (lib'.flocken.getModules ./.);

  environment.systemPackages = with pkgs; [ _1password ];

  system.stateVersion = stateVersionDarwin;
}
