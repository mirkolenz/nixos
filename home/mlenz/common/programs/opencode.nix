{ lib, config, ... }:
lib.mkIf config.custom.profile.isWorkstation {
  programs.opencode = {
    enable = true;
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
