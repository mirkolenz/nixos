{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.custom.profile.isWorkstation {
  # https://ampcode.com/manual#configuration
  programs.amp-cli = {
    enable = true;
    package = pkgs.amp-cli-bin;
    settings.amp = {
      git.commit = {
        ampThread.enabled = true;
        coauthor.enabled = false;
      };
      updates.mode = "disabled";
    };
  };
}
