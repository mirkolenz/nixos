{
  config,
  pkgs,
  ...
}: {
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

  # Not working due to failing `lenovo_fix.service`
  # services.throttled.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
}
