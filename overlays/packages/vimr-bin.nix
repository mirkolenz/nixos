{
  mkApp,
  lib,
  fetchzip,
  rcodesign,
  nix-update-script,
}:
mkApp rec {
  pname = "vimr";
  version = "0.54.0-20250531.222551";
  appname = "VimR";

  src = fetchzip {
    url = "https://github.com/qvacua/vimr/releases/download/v${version}/${appname}-v${lib.head (lib.splitString "-" version)}.tar.bz2";
    hash = "sha256-iRFBcY43tBOvNAAkTBmO6eMZQHg0LP7NqNJTdumfujU=";
    stripRoot = false;
  };
  wrapperPath = "Contents/Resources/${pname}";

  nativeBuildInputs = [
    rcodesign
  ];

  preInstall = ''
    rcodesign sign ${appname}.app
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(.*)"
    ];
  };

  meta = {
    description = "Neovim GUI for macOS in Swift";
    homepage = "https://github.com/qvacua/vimr";
    downloadPage = "https://github.com/qvacua/vimr/releases";
    license = lib.licenses.mit;
  };
}
