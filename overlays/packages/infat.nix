{
  lib,
  swiftPackages,
  swift,
  swiftpm,
  fetchFromGitHub,
  ...
}:
swiftPackages.stdenv.mkDerivation rec {
  pname = "infat";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "philocalyst";
    repo = "infat";
    tag = "v${version}";
    hash = "sha256-BntWmQ7NOkXL07hMJZNyJbZ6cFm7swTZXm6w2KFz/UU=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildPhase = ''
    runHook preBuild

    swift build \
      -c release \
      -Xswiftc "-whole-module-optimization" \
      --triple "$(uname -m)-apple-macos" \
      -Xlinker "-dead_strip"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -v .build/release/infat $out/bin/infat

    runHook postInstall
  '';

  meta = {
    description = "Command line tool to set default openers for file formats and url schemes on macos";
    homepage = "https://github.com/philocalyst/infat";
    license = lib.licenses.mit;
    mainProgram = pname;
    maintainers = with lib.maintainers; [ mirkolenz ];
    platforms = lib.platforms.darwin;
    # requires swift 5.9, but only 5.8 is available
    broken = lib.platforms.darwin;
  };
}
