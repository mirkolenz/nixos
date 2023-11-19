{lib, ...}: {
  services.openssh.enable = lib.mkDefault true;
}
