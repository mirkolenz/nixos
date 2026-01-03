{ lib, config, ... }:
lib.mkIf config.custom.profile.isWorkstation {
  programs.yt-dlp = {
    enable = true;
    settings = {
      embed-metadata = true;
      embed-thumbnail = true;
      no-playlist = true;
    };
  };
}
