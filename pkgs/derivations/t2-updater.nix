{
  lib,
  inputs,
  writers,
  python3Packages,
}:
writers.writePython3Bin "t2-updater" {
  libraries = with python3Packages; [ requests ];
  doCheck = false;
} (lib.readFile "${inputs.nixos-hardware}/apple/t2/pkgs/linux-t2/update-patches.py")
