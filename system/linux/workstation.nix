{
  lib,
  config,
  user,
  ...
}:
lib.mkIf (config.custom.profile == "workstation") {
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

  networking.networkmanager.enable = true;
  systemd.network.wait-online.enable = false;
  users.users.${user.login}.extraGroups = [ "networkmanager" ];

  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ user.login ];
    };
  };

  nix.settings.trusted-users = [ user.login ];
}
