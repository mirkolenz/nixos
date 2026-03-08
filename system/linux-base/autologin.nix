{ lib, config, ... }:
lib.mkIf (config.custom.profile.isDesktop && config.services.displayManager.autoLogin.enable) {

  # enabled by cosmic but make sure it's actually set
  services.gnome.gnome-keyring.enable = true;

  # cosmic runs on greetd, and display-manager.service is an alias of greetd.service.
  systemd.services.greetd.serviceConfig.KeyringMode = "inherit";

  # https://wiki.nixos.org/wiki/Full_Disk_Encryption#autologin-using-luks-password
  security.pam.services.greetd = {
    enableGnomeKeyring = true;

    rules.auth.systemd_loadkey = {
      order = config.security.pam.services.greetd.rules.auth.gnome_keyring.order - 10;
      control = "optional";
      modulePath = "${config.systemd.package}/lib/security/pam_systemd_loadkey.so";
    };
  };
}
