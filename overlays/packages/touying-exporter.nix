{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "touying-exporter";
  version = "0.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "touying-typ";
    repo = "touying-exporter";
    tag = version;
    hash = "sha256-gcr3KS2Qm8CMA+8AeC0hbGi9Gjj5sMr6gJkuoZWUEGY=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    jinja2
    pillow
    python-pptx
    typst
  ];

  pythonRemoveDeps = [
    "argparse"
  ];

  pythonImportsCheck = [
    "touying"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Export presentation slides in various formats for Touying";
    homepage = "https://github.com/touying-typ/touying-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "touying";
  };
}
