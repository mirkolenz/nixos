{
  lib',
  modulesPath,
  ...
}:
{
  imports = lib'.flocken.getModules ./. ++ [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  custom.features = {
    withDisplay = true;
    withOptionals = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };

  # https://docs.getutm.app/guest-support/linux/#virtfs
  fileSystems."/mnt/utm" = {
    device = "share";
    fsType = "9p";
    options = [
      "trans=virtio"
      "version=9p2000.L"
      "rw"
      "_netdev"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
    ];
  };
}
