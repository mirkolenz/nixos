{mylib, ...}: {
  imports = mylib.flocken.getModules ./.;

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };
}
