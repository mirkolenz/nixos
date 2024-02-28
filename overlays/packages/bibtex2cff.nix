{
  poetry2nix,
  python3,
  fetchFromGitHub,
}:
poetry2nix.mkPoetryApplication rec {
  pname = "bibtex2cff";
  version = "0.2.1";
  projectDir = src;
  src = fetchFromGitHub {
    owner = "anselmoo";
    repo = "bibtex2cff";
    rev = "v${version}";
    hash = "sha256-Xuj2kDJzX2owIjjBRrfXNJCZeGRZ7OoD1X+ibU4b1C8=";
  };
  preferWheels = true;
  python = python3;
  meta = { };
}
