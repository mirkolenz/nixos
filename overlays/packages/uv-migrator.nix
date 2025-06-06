{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "uv-migrator";
  version = "2025.8.1";
  useFetchCargoVendor = true;
  # nix-update --flake uv-migrator

  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = "uv-migrator";
    tag = "v${version}";
    hash = "sha256-SzO9Z2y7LQ+AE90pGN734Z+0FOa3mcDeI7KMKqoWW4o=";
  };

  cargoHash = "sha256-DsK8hDftdkVxxWuxCa8iHCDsD7huQAomj2fMSA7LjOY=";

  meta = {
    description = "Tool for migrating to the uv package manager";
    homepage = "https://github.com/stvnksslr/uv-migrator";
    changelog = "https://github.com/stvnksslr/uv-migrator/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "uv-migrator";
  };
}
