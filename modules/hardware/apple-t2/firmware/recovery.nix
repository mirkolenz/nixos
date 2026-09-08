# Downloads a macOS recovery image from Apple at build time. The blobs end up in
# the nix store, which needs `allowUnfree`, so this is the fallback for machines
# whose own macOS install is gone.
#
# Stays inline rather than moving to pkgs/by-name: it is an override of a
# derivation nixos-hardware builds inside a VM, and `vmTools.runInLinuxVM`
# yields something with `overrideDerivation` but no `overrideAttrs`, which the
# by-name update-script guard needs.
# https://wiki.t2linux.org/guides/wifi-bluetooth/ (method 5)
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
      cfg = config.custom.apple-t2.firmware;

      # https://github.com/kholia/OSX-KVM/blob/4c378a4b5e0b219783683012bec680325eb40719/fetch-macOS-v2.py#L547
      fetchmacos =
        pkgs.callPackage "${inputs.nixos-hardware}/apple/t2/pkgs/brcm-firmware/fetchmacos.nix"
          { };

      firmware = pkgs.callPackage "${inputs.nixos-hardware}/apple/t2/pkgs/brcm-firmware" {
        # Only selects one of the `boards` entries upstream knows about; both it
        # and the resulting version are replaced below.
        version = "sonoma";
      };

      version = "tahoe";

      # mkDerivation computes name and version before the override applies, so
      # both have to be set directly instead of through the argument above.
      patchedFirmware = firmware.overrideDerivation (_old: {
        inherit version;
        name = "brcm-firmware-${version}";
        src = fetchmacos {
          name = version;
          boardId = "Mac-CFF7D910A743CAAF";
          mlb = "00000000000000000";
          osType = "default";
          hash = "sha256-l3PIhInQJeSmYIaxObgFDvZN40u2GgkPrqYaginTCvs=";
        };
      });
    in
    {
      hardware.firmware = lib.mkIf (cfg.enable && cfg.source == "recovery") [ patchedFirmware ];
    };
}
