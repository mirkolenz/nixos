{ self, lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  i18n.defaultLocale = "de_DE.UTF-8";
  networking.firewall.enable = true;
  services.openssh.enable = true;

  home-manager.users = {
    mirko = self.homeModules.linux;
  };
}
