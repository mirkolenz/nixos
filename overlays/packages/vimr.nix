{
  mkApp,
  lib,
  fetchurl,
}:
mkApp rec {
  pname = "vimr";
  version = "0.49.0";
  build = "20241006.202133";
  appname = "VimR";
  src = fetchurl {
    url = "https://github.com/qvacua/vimr/releases/download/v${version}-${build}/${appname}-v${version}.tar.bz2";
    hash = "sha256-b+BA4ABy/Wjsxnz9LQyR5ZEZOQGHk1Oiq03y2I6l9Vc=";
  };
  postInstall = ''
    makeWrapper "$out/Applications/${appname}.app/Contents/Resources/vimr" "$out/bin/${pname}"
  '';
  meta = {
    description = "Neovim GUI for macOS in Swift";
    homepage = "https://github.com/qvacua/vimr";
    downloadPage = "https://github.com/qvacua/vimr/releases";
    license = with lib.licenses; [ mit ];
  };
}
