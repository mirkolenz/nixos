{
  pkgs,
  ...
}:
{
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "de";
      excludePackages = with pkgs; [ xterm ];
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };

  security.rtkit.enable = true;

  hardware.graphics.enable = true;
}
