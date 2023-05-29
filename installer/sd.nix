{...}: {
  imports = [./base.nix];
  sdImage = {
    compressImage = false;
  };
  boot = {
    tmpOnTmpfs = true;
    # default is 50% of RAM, but builds fail with 8G Raspi 4
    tmpOnTmpfsSize = "16G";
  };
}
