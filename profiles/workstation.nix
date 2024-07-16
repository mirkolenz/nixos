{ config, user, ... }:
{
  services.xserver.enable = true;
  services.printing.enable = true;

  security.rtkit.enable = config.services.pipewire.enable;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  networking.networkmanager.enable = true;
  systemd.network.wait-online.enable = false;
  users.users.${user.login}.extraGroups = [ "networkmanager" ];

  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ user.login ];
    };
  };
}
