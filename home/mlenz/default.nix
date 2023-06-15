{
  pkgs,
  extras,
  lib,
  osConfig,
  ...
}: let
  username = "mlenz";
  homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";
in {
  imports = [
    ./xserver.nix
    ./programs
    ./files
    ./packages
  ];

  home = {
    inherit username homeDirectory;
    inherit (extras) stateVersion;
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };

  nix = {
    package = lib.mkIf (osConfig == {}) pkgs.nix;
  };
}
