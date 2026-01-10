{
  writers,
  python3Packages,
}:
writers.writePython3Bin "flake-updater" {
  libraries = with python3Packages; [
    pygithub
    typer
  ];
  doCheck = false;
} ./script.py
