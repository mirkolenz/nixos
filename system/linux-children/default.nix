{
  self,
  lib,
  lib',
  user,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  i18n.defaultLocale = "de_DE.UTF-8";
  networking.firewall.enable = true;
  services.openssh.enable = true;
  nix.settings = {
    allowed-users = lib.mkForce [ "mirko" ];
    trusted-users = lib.mkForce [
      "root"
      "mirko"
    ];
  };

  home-manager.users.mirko = {
    imports = [ self.homeModules.linux ];
    _module.args.user = lib.mkForce (user // { login = "mirko"; });
  };
}
