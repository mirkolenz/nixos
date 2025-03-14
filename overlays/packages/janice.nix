{
  autoPatchelfHook,
  buildGoModule,
  fetchFromGitHub,
  lib,
  libGL,
  libxkbcommon,
  pkg-config,
  stdenv,
  wayland,
  xorg,
}:
buildGoModule rec {
  pname = "janice";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ErikKalkoken";
    repo = "janice";
    tag = "v${version}";
    hash = "sha256-OUvOq93hRU4rh3To6VTS7iA/CXcXTtsSrsIrQDfVUiU=";
  };

  vendorHash = "sha256-fYlEhHarCru+LMcE+k/0XC6CpAlpH3nhCtNlinZDv4s=";

  ldflags = [
    "-s"
    "-w"
  ];

  # https://docs.fyne.io/started/
  buildInputs = lib.optionals stdenv.isLinux [
    libGL
    libxkbcommon
    wayland
    xorg.libX11.dev
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXxf86vm
  ];

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
    autoPatchelfHook
  ];

  meta = {
    description = "A desktop app for viewing large JSON files";
    homepage = "https://github.com/ErikKalkoken/janice";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "janice";
  };
}
