{
  mkApp,
  lib,
  fetchurl,
}:
mkApp rec {
  pname = "vimr";
  version = "0.48.0";
  build = "20240727.082947";
  appname = "VimR";
  src = fetchurl {
    url = "https://github.com/qvacua/vimr/releases/download/v${version}-${build}/${appname}-v${version}.tar.bz2";
    hash = "sha256-0hkVEHODIzJ6iTpRaAlaqSjdi9Tlj7kN4tFOZ7RxkCg=";
  };
  postInstall = ''
    mkdir -p "$out/bin"
    makeWrapper "$out/Applications/${appname}.app/Contents/Resources/vimr" "$out/bin/${pname}"
  '';
  meta = {
    description = "Neovim GUI for macOS in Swift";
    homepage = "https://github.com/qvacua/vimr";
    downloadPage = "https://github.com/qvacua/vimr/releases";
    license = with lib.licenses; [ mit ];
  };
}
