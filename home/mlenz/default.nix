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
  ];

  home = {
    inherit username homeDirectory;
    inherit (extras) stateVersion;
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
    packages = lib.mkIf (osConfig == {}) [
      (pkgs.writeShellApplication {
        name = "sudo";
        text = ''
          cmd=$(which "$1")
          shift
          /usr/bin/sudo "$cmd" "$@"
        '';
      })
    ];
  };
}
