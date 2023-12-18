{mylib, ...}: {
  imports = mylib.getModules ./.;

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };
}
