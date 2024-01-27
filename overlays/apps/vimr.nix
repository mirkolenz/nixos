{
  mkApp,
  lib,
  fetchurl,
}:
mkApp rec {
  pname = "vimr";
  version = "0.45.5";
  build = "20231223.144003";
  appname = "VimR";
  src = fetchurl {
    url = "https://github.com/qvacua/vimr/releases/download/v${version}-${build}/${appname}-v${version}.tar.bz2";
    hash = "sha256-qjcEfXzXxCdJSgJqK+5ae4h8ZvxJmVlF+zBloYaea6k=";
  };
  postInstall = ''
    mkdir -p "$out/bin"
    makeWrapper "$out/Applications/${appname}.app/Contents/Resources/vimr" "$out/bin/${pname}"
  '';
  meta = {
    description = "Neovim GUI for macOS in Swift";
    homepage = "https://github.com/qvacua/vimr";
    downloadPage = "https://github.com/qvacua/vimr/releases";
    license = with lib.licenses; [mit];
  };
}
