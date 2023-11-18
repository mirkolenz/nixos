{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    ./hardware.nix
    ../../templates/headless.nix
  ];
  networking.hostName = "macbook-9-1";

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  powerManagement.cpuFreqGovernor = "powersave";
}
