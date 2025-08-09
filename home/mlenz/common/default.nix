{
  pkgs,
  lib',
  user,
  stateVersions,
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
    };
  };
}
