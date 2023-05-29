{...}: {
  imports = [./base.nix];
  isoImage = {
    compressImage = false;
    squashfsCompression = "gzip -Xcompression-level 1";
  };
}
