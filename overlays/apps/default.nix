# https://github.com/jwiegley/nix-config/blob/master/overlays/30-apps.nix
# https://cmacr.ae/blog/managing-firefox-on-macos-with-nix/
final: prev: {
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
  neovide-bin = final.callPackage ./neovide.nix {};
  vimr-bin = final.callPackage ./vimr.nix {};
}
