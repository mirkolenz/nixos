# https://wiki.t2linux.org/distributions/nixos/installation/
# https://github.com/nix-community/disko/blob/master/example/luks-btrfs-subvolumes.nix
{
  # Only manages the Linux partition (nvme0n1p3)
  # Does NOT touch macOS EFI (nvme0n1p1) or APFS (nvme0n1p2) partitions
  disko.devices.luks.root = {
    type = "luks";
    device = "/dev/disk/by-id/nvme-APPLE_SSD_AP1024N_C02001700E3N9V014-part3";
    name = "cryptroot";
    passwordFile = "/tmp/secret.key"; # Interactive
    # settings.keyFile = "/tmp/secret.key"; # Non-interactive
    settings.allowDiscards = true;
    content = {
      type = "btrfs";
      extraArgs = [ "-f" ];
      subvolumes = {
        "/root" = {
          mountpoint = "/";
          mountOptions = [
            "compress=zstd"
            "noatime"
          ];
        };
        "/home" = {
          mountpoint = "/home";
          mountOptions = [
            "compress=zstd"
            "noatime"
          ];
        };
        "/nix" = {
          mountpoint = "/nix";
          mountOptions = [
            "compress=zstd"
            "noatime"
          ];
        };
      };
    };
  };
}
