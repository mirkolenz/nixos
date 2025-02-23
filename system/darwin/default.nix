{
  lib',
  pkgs,
  stateVersions,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  environment.systemPackages = with pkgs; [ _1password-cli ];

  system.stateVersion = stateVersions.darwin;

  security.sudo.extraConfig = ''
    Defaults env_keep -= "HOME"
  '';
}
