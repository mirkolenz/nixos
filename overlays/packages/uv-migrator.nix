{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "uv-migrator";
  version = "2025.6.0";
  useFetchCargoVendor = true;

  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = "uv-migrator";
    tag = "v${version}";
    hash = "sha256-Svb4ohaiC8wHMn/JtQUcX5fN1GmV4LhYfDETyWJfRTE=";
  };

  cargoHash = "sha256-c3Kqp/WSCR42PmCdBqGGj+G0soSJcGssNscaBtbiDrA=";

  meta = {
    description = "Tool for migrating to the uv package manager";
    homepage = "https://github.com/stvnksslr/uv-migrator";
    changelog = "https://github.com/stvnksslr/uv-migrator/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "uv-migrator";
  };
}
