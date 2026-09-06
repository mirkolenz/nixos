{
  inputs,
  config,
  ...
}:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.macbook-161 = {
    system = "x86_64-linux";
    module =
      {
        pkgs,
        ...
      }:
      {
        imports = [
          nixos.default
          "${inputs.nixos-hardware}/apple"
          "${inputs.nixos-hardware}/apple/t2"
          "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake/cpu-only.nix"
          "${inputs.nixos-hardware}/common/pc/laptop"
          "${inputs.nixos-hardware}/common/pc/ssd"
        ];

        custom.features = {
          graphical.desktopManager = "cosmic";
          extras.enable = true;
        };

        boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
        boot.loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
          efi.efiSysMountPoint = "/boot";
        };

        swapDevices = [
          {
            device = "/swapfile";
            size = 4 * 1024;
          }
        ];

        # https://wiki.t2linux.org/guides/postinstall/
        # https://github.com/NixOS/nixos-hardware/blob/master/apple/t2/default.nix
        hardware.apple-t2.enableIGPU = true;
        hardware.apple-t2-firmware.enable = true;

        # The T2 chip exposes an internal USB ethernet interface with no Linux support.
        # Keep it down in networkd and hide it from NetworkManager.
        # https://wiki.t2linux.org/guides/postinstall/
        systemd.network.networks."10-t2-ethernet" = {
          matchConfig.MACAddress = "ac:de:48:00:11:22";
          linkConfig = {
            ActivationPolicy = "manual";
            RequiredForOnline = false;
          };
        };
        networking.networkmanager.unmanaged = [ "mac:ac:de:48:00:11:22" ];

        environment.systemPackages = with pkgs; [
          brightnessctl
        ];

        # https://github.com/AsahiLinux/tiny-dfr/blob/master/share/tiny-dfr/config.toml
        hardware.apple.touchBar = {
          enable = true;
          settings = {
            MediaLayerDefault = true;
          };
        };
      };
  };
}
