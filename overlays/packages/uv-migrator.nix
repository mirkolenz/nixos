{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "uv-migrator";
  version = "2025.7.1";
  useFetchCargoVendor = true;

  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = "uv-migrator";
    tag = "v${version}";
    hash = "sha256-LJwOntnLJNSy5CEJuj3+qL1+y8ia537P2Wl6GYgH4x8=";
  };

  cargoHash = "sha256-qHMtVFdRgfpXqivb45JWvmV1WrWPocAos1sI0GQF7so=";

  meta = {
    description = "Tool for migrating to the uv package manager";
    homepage = "https://github.com/stvnksslr/uv-migrator";
    changelog = "https://github.com/stvnksslr/uv-migrator/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "uv-migrator";
  };
}
