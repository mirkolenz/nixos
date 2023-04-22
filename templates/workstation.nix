{ ... }:
{
  imports = [
    ../system/common
    ../system/linux
    ../system/tools.nix
  ];

  services.xserver.enable = true;
  services.printing.enable = true;

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
}
