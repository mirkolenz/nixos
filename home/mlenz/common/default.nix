{
  pkgs,
  lib',
  user,
  stateVersions,
  lib,
  config,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  home = {
    stateVersion = stateVersions.home;
    username = user.login;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user.login}" else "/home/${user.login}";
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      BROWSER = lib.mkIf config.custom.profile.isHeadless "echo";
    };
  };
}
