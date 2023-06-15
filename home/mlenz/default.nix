{
  pkgs,
  extras,
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

  nixpkgs.config = osConfig.nixpkgs.config;

  home = {
    inherit username homeDirectory;
    inherit (extras) stateVersion;
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };
}
