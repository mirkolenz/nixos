{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.custom.profile.isDesktop {
  services.xserver.xkb.layout = "de";

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    focuswriter
  ];
}
