{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.custom.features.withOptionals {
  programs.mistral-vibe = {
    enable = true;
    package = pkgs.mistral-vibe;
    # https://github.com/mistralai/mistral-vibe/blob/main/README.md
    # https://github.com/mistralai/mistral-vibe/blob/main/vibe/core/config/_settings.py
    settings = {
      active_model = "devstral-2";
      enable_auto_update = false;
      enable_notifications = true;
      enable_telemetry = false;
      enable_update_checks = false;
      disable_welcome_banner_animation = true;
    };
  };
}
