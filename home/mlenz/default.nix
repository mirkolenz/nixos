{
  pkgs,
  lib',
  inputs,
  user,
  stateVersion,
  ...
}:
let
  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user.login}" else "/home/${user.login}";
in
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ] ++ (lib'.flocken.getModules ./.);

  home = {
    inherit homeDirectory stateVersion;
    username = user.login;
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      HOMEBREW_AUTOREMOVE = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };
}
