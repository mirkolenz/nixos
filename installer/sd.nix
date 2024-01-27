{ ... }:
{
  imports = [ ./base.nix ];
  sdImage = {
    compressImage = false;
  };
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "16G";
  };
}
