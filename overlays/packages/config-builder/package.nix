{
  writers,
  python3Packages,
}:
writers.writePython3Bin "config-builder" {
  libraries = with python3Packages; [ typer ];
  doCheck = false;
} ./script.py
