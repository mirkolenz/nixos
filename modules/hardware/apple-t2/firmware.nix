# Wi-Fi and Bluetooth firmware extracted from a macOS recovery image.
# Upstream only ships images up to Sonoma, so a newer one is substituted here.
{
  flake.modules.nixos.apple-t2 =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    let
      # https://github.com/kholia/OSX-KVM/blob/4c378a4b5e0b219783683012bec680325eb40719/fetch-macOS-v2.py#L547
      fetchmacos =
        pkgs.callPackage "${inputs.nixos-hardware}/apple/t2/pkgs/brcm-firmware/fetchmacos.nix"
          { };
      firmware = pkgs.callPackage "${inputs.nixos-hardware}/apple/t2/pkgs/brcm-firmware" {
        # Only selects one of the `boards` entries upstream knows about; both it and
        # the resulting version are replaced below.
        version = "sonoma";
      };
      # mkDerivation computes name and version before the override applies, so both
      # have to be set directly instead of through the argument above.
      patchedFirmware = firmware.overrideDerivation (_old: {
        name = "brcm-firmware-tahoe";
        version = "tahoe";
        src = fetchmacos {
          name = "tahoe";
          boardId = "Mac-CFF7D910A743CAAF";
          mlb = "00000000000000000";
          osType = "default";
          hash = "sha256-l3PIhInQJeSmYIaxObgFDvZN40u2GgkPrqYaginTCvs=";
        };
      });
    in
    {
      options.custom.apple-t2.firmware = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to install the Broadcom Wi-Fi and Bluetooth firmware";
        };

        # nix build .#nixosConfigurations.macbook-161.config.custom.apple-t2.firmware.package
        package = lib.mkOption {
          type = lib.types.package;
          default = patchedFirmware;
          description = "Broadcom firmware for the Wi-Fi and Bluetooth chips of T2 Macs";
        };
      };

      config.hardware.firmware = lib.mkIf config.custom.apple-t2.firmware.enable [
        config.custom.apple-t2.firmware.package
      ];
    };
}
