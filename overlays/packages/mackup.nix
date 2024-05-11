# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/litellm/default.nix
{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
let
  pname = "mackup";
  version = "0.8.40";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "lra";
    repo = "mackup";
    rev = version;
    hash = "sha256-hAIl9nGFRaROlt764IZg4ejw+b1dpnYpiYq4CB9dJqQ=";
  };

  nativeBuildInputs = with python3Packages; [ poetry-core ];

  propagatedBuildInputs = with python3Packages; [
    docopt
    six
  ];

  checkInputs = with python3Packages; [ nose ];

  meta = {
    description = "Keep your application settings in sync (OS X/Linux)";
    homepage = "https://github.com/lra/mackup";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "mackup";
  };
}
