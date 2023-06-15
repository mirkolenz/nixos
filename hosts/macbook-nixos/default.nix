{config, ...}: {
  imports = [
    ./hardware.nix
    ../../templates/workstation.nix
  ];
  networking.hostName = "macbook-nixos";
  services.openssh.enable = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  custom.cuda = {
    enable = true;
    driver = "legacy_470";
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
}
