{
  lib,
  config,
  user,
  ...
}:
lib.mkIf config.custom.profile.isDesktop {
  services.xserver.xkb.layout = "us";

  users.users.${user.login}.extraGroups = [ "networkmanager" ];

  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ user.login ];
    };
  };
}
