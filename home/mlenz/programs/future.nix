{
  lib,
  pkgs,
  extras,
  ...
}:
lib.optionalAttrs (lib.versionAtLeast lib.trivial.release "23.11") {
  programs = {
    ripgrep = {
      enable = true;
    };
    thefuck = {
      enable = true;
    };
    eza = {
      enable = true;
      enableAliases = true;
      extraOptions = [
        "--long"
        "--group-directories-first"
        "--color=always"
        "--time-style=long-iso"
      ];
      git = true;
      icons = true;
    };
  };
}
