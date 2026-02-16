{
  lib,
  config,
  user,
  pkgs,
  ...
}:
lib.mkIf config.custom.profile.isDesktop {
  services.xserver.xkb.layout = "us";

  # Packages
  environment.systemPackages = with pkgs; [
    anydesk
    vivaldi
    firefox
    obsidian
    zoom-us
    zotero
  ];

  users.users.${user.login}.extraGroups = [ "networkmanager" ];

  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ user.login ];
    };
  };

  nix.settings.trusted-users = [ user.login ];
}
