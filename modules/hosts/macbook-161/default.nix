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
          nixos.apple-t2
          "${inputs.nixos-hardware}/apple"
          "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake/cpu-only.nix"
          "${inputs.nixos-hardware}/common/pc/laptop"
          "${inputs.nixos-hardware}/common/pc/ssd"
        ];

        custom.apple-t2.firmware.enable = true;
        custom.features = {
          graphical.desktopManager = "gnome";
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
