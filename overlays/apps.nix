# https://github.com/jwiegley/nix-config/blob/master/overlays/30-apps.nix
# https://cmacr.ae/blog/managing-firefox-on-macos-with-nix/
final: prev: let
  mkApp = args @ {
    pname,
    version,
    src,
    appname ? pname,
    meta ? {},
    nativeBuildInputs ? [],
    ...
  }:
    final.stdenvNoCC.mkDerivation (
      {
        phases = ["unpackPhase" "installPhase"];
        sourceRoot = "${appname}.app";
        installPhase = ''
          runHook preInstall

          mkdir -p "$out/Applications/${appname}.app"
          cp -R . "$out/Applications/${appname}.app"

          runHook postInstall
        '';
        # all of the following attributes need to removed from args
        nativeBuildInputs = nativeBuildInputs ++ (with final; [unzip undmg makeWrapper]);
        meta =
          {
            maintainers = with final.lib.maintainers; [mirkolenz];
            platforms = final.lib.platforms.darwin;
            sourceProvenance = with final.lib.sourceTypes; [binaryNativeCode];
            mainProgram = pname;
          }
          // meta;
      }
      // (builtins.removeAttrs args ["nativeBuildInputs" "meta"])
    );
in {
  # https://github.com/NixOS/nixpkgs/pull/222451
  neovide-bin = mkApp rec {
    pname = "neovide";
    version = "0.12.0";
    appname = "Neovide";
    src = final.fetchzip {
      url = "https://github.com/neovide/neovide/releases/download/${version}/${pname}.dmg.zip";
      hash = "sha256-mnOqybXBclikGnVvqgx12GOiVY6zUa9xaLS12M5BhpA=";
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
      license = with final.lib.licenses; [mit];
    };
  };
  vimr-bin = mkApp rec {
    pname = "vimr";
    version = "0.45.5";
    build = "20231223.144003";
    appname = "VimR";
    src = final.fetchurl {
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
      license = with final.lib.licenses; [mit];
    };
  };
}
