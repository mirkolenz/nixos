{
  lib,
  pkgs,
  extras,
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
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    inherit username homeDirectory;
    inherit (extras) stateVersion;
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };
}
