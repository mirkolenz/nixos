{
  lib,
  pkgs,
  extras,
  ...
}:
lib.optionalAttrs (lib.versionAtLeast lib.trivial.release "23.11") {
  programs = {
    carapace = {
      enable = true;
    };
    ripgrep = {
      enable = true;
    };
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = extras.user.name;
          email = extras.user.mail;
        };
      };
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
