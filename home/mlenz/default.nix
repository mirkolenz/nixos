{
  pkgs,
  lib',
  inputs,
  user,
  stateVersion,
  channel,
  self,
  lib,
  ...
}:
let
  # https://nix-community.github.io/nixvim/modules/standalone.html
  inherit (pkgs.stdenv.hostPlatform) system;
  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user.login}" else "/home/${user.login}";
  vim = self.packages.${system}."vim-${channel}";
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
      EDITOR = lib.mkDefault "nvim";
    };
    packages = [ vim ];
  };
}
