{lib', ...}: {
  imports = lib'.flocken.getModules ./.;

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };
}
