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

  hardware = {
    opengl.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
      modesetting.enable = true;
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
}
