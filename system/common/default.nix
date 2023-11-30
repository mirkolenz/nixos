{mylib, ...}: {
  imports = mylib.importFolder ./.;

  # networking.firewall = {
  #   enable = true;
  #   allowPing = true;
  # };
}
