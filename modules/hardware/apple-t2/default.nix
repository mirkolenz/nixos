# Support for Macs with an Apple T2 security chip, replacing the upstream
# `nixos-hardware/apple/t2` module: the t2bce driver stack needs a different
# kernel config and a different audio setup than the one shipped upstream.
# Shared by the macbook-161 host and the T2 installer ISO.
# https://wiki.t2linux.org/guides/postinstall/
# https://github.com/NixOS/nixos-hardware/blob/master/apple/t2/default.nix
{
  flake.modules.nixos.apple-t2 = {
    # Needed for audio and suspend, post-resume.service comes from powerManagement
    boot.kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "pm_async=off"
    ];
    powerManagement.enable = true;
  };
}
