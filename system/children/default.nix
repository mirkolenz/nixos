{ self, lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  home-manager.users = {
    mirko = self.homeModules.linux;
  };
}
