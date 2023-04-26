{ ... }:
{
  imports = [ ./base.nix ];
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
