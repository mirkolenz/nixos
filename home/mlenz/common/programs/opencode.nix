{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.custom.profile.isWorkstation {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode-bin;
    # https://opencode.ai/docs/config/
    settings = {
      share = "disabled";
      autoupdate = false;
    };
  };
  home.sessionVariables = {
    OPENCODE_EXPERIMENTAL = "1";
  };
}
