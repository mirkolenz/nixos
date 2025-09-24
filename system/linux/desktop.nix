{
  lib,
  config,
  user,
  ...
}:
lib.mkIf config.custom.profile.isDesktop {
  services.xserver.enable = true;

  security.rtkit.enable = config.services.pipewire.enable;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  hardware.graphics.enable = true;

  systemd.network.wait-online.anyInterface = true;
  boot.initrd.systemd.network.wait-online.anyInterface = true;
  networking.networkmanager.enable = true;
  users.users.${user.login}.extraGroups = [ "networkmanager" ];

  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ user.login ];
    };
  };

  nix.settings.trusted-users = [ user.login ];
}
