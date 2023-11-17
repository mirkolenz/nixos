{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    ./hardware.nix
    ../../templates/workstation.nix
  ];
  networking.hostName = "macbook-legacy";
  services.openssh.enable = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  powerManagement.cpuFreqGovernor = "powersave";
}
