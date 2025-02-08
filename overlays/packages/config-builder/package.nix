{
  writers,
  lib,
  python3Packages,
}:
writers.writePython3Bin "config-builder" {
  libraries = with python3Packages; [ typer ];
  flakeIgnore = [
    "E203"
    "E501"
  ];
} ./script.py
