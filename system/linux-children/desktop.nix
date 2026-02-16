{lib, config, ... }:
lib.mkIf config.custom.profile.isDesktop {
  services.xserver.xkb.layout = "de";

  programs.firefox.enable = true;
}
