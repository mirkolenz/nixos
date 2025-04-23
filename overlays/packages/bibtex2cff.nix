{
  python3Packages,
  fetchFromGitHub,
  lib,
}:
python3Packages.buildPythonApplication rec {
  pname = "bibtex2cff";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anselmoo";
    repo = "bibtex2cff";
    tag = "v${version}";
    hash = "sha256-Xuj2kDJzX2owIjjBRrfXNJCZeGRZ7OoD1X+ibU4b1C8=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies =
    with python3Packages;
    [
      bibtexparser
      pydantic_1
      pyyaml
    ]
    ++ pydantic_1.optional-dependencies.email;

  nativeCheckInputs = with python3Packages; [
    pytest
    pytest-cov
    flake8
    black
    isort
    mypy
    pydocstyle
    pylint
    bandit
    types-pyyaml
  ];

  meta = {
    description = "Convert from bibtex to CITATION.cff";
    homepage = "https://github.com/Anselmoo/bibtex2cff";
    downloadPage = "https://github.com/Anselmoo/bibtex2cff/releases";
    license = lib.licenses.mit;
    mainProgram = "bibtex2cff";
    platforms = with lib.platforms; darwin ++ linux;
    maintainers = with lib.maintainers; [ mirkolenz ];
  };
}
