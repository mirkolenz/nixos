# https://nixos.wiki/wiki/NixOS_on_ARM#Installation
{...}: {
  imports = [
    ./hardware.nix
    ../../templates/server.nix
  ];
  networking.hostName = "raspi";
  boot.binfmt.emulatedSystems = ["x86_64-linux"];

  hardware.raspberry-pi."4" = {
    # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/poe-plus-hat.nix
    poe-plus-hat.enable = true;
    # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/audio.nix
    # TODO: Currently broken
    audio.enable = false;
  };

  powerManagement.cpuFreqGovernor = "ondemand";
}
