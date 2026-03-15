{
  lib,
  config,
  user,
  ...
}:
lib.mkIf config.custom.features.withDisplay {
  services.xserver.xkb.layout = "us";

  users.users.${user.login}.extraGroups = [ "networkmanager" ];

  programs._1password-gui.polkitPolicyOwners = [ user.login ];

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      vivaldi-bin
    '';
    mode = "0755";
  };
}
