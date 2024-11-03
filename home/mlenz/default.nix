{
  pkgs,
  lib',
  inputs,
  user,
  stateVersions,
  ...
}:
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ] ++ (lib'.flocken.getModules ./.);

  home = {
    stateVersion = stateVersions.home;
    username = user.login;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user.login}" else "/home/${user.login}";
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      HOMEBREW_AUTOREMOVE = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };
}
