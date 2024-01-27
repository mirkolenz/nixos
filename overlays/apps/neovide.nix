# https://github.com/NixOS/nixpkgs/pull/222451
{
  mkApp,
  fetchzip,
  lib,
}:
mkApp rec {
  pname = "neovide";
  version = "0.12.1";
  appname = "Neovide";
  src = fetchzip {
    url = "https://github.com/neovide/neovide/releases/download/${version}/${pname}.dmg.zip";
    hash = "sha256-2DiF2DPK2hKlL+c04xUG4BehzBvQ1hWhaMH+WWN09aE=";
  };
  # undmg cannot handle APFS dmg files, so we need to mount it manually
  unpackCmd = ''
    /usr/bin/hdiutil mount "$curSrc/${pname}.dmg"
    cp -R /Volumes/${pname}/${appname}.app .
    /usr/bin/hdiutil unmount /Volumes/${pname}
  '';
  postInstall = ''
    mkdir -p "$out/bin"
    makeWrapper "$out/Applications/${appname}.app/Contents/MacOS/neovide" "$out/bin/${pname}"
  '';
  meta = {
    description = "No Nonsense Neovim Client in Rust";
    homepage = "https://neovide.dev";
    downloadPage = "https://github.com/neovide/neovide/releases";
    license = with lib.licenses; [ mit ];
  };
}
