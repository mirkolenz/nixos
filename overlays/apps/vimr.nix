{
  mkApp,
  lib,
  fetchurl,
}:
mkApp rec {
  pname = "vimr";
  version = "0.46.1";
  build = "20240114.181346";
  appname = "VimR";
  src = fetchurl {
    url = "https://github.com/qvacua/vimr/releases/download/v${version}-${build}/${appname}-v${version}.tar.bz2";
    hash = "sha256-M6q75zYEX5kB6JzvP959inWPOe/KA5unhzx5Ybee5To=";
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
