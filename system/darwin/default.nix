{
  lib',
  pkgs,
  stateVersionDarwin,
  ...
}:
{
  imports = [ ../common ] ++ (lib'.flocken.getModules ./.);

  environment.loginShell = pkgs.fish;

  environment.systemPackages = with pkgs; [ _1password ];

  system.stateVersion = stateVersionDarwin;
}
