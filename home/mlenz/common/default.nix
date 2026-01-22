{
  pkgs,
  lib',
  user,
  stateVersions,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  xdg.enable = true;

  home = {
    stateVersion = stateVersions.home;
    username = user.login;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user.login}" else "/home/${user.login}";
    sessionVariables = {
      PAGER = "less";
      MANPAGER = "bat -plman";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
    file = {
      ".hushlogin".text = "";
    };
  };
}
