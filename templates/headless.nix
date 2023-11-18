{lib, ...}: {
  imports = [
    ../system/common
    ../system/linux
  ];

  services.openssh.enable = lib.mkDefault true;
}
