{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "uv-migrator";
  version = "2025.8.0";
  useFetchCargoVendor = true;
  # nix-update --flake uv-migrator

  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = "uv-migrator";
    tag = "v${version}";
    hash = "sha256-VvgMhzmkr6mI3WRIGLKcBi18SZO9Oqcv/zuU/WC+pDk=";
  };

  cargoHash = "sha256-bdBgijlRMMzsORgeB1Qv/8yF/z5mfwvtnG5bSQD7MoU=";

  meta = {
    description = "Tool for migrating to the uv package manager";
    homepage = "https://github.com/stvnksslr/uv-migrator";
    changelog = "https://github.com/stvnksslr/uv-migrator/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "uv-migrator";
  };
}
