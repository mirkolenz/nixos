# The t2bce audio driver exposes a plain ALSA device, so its use case profiles
# have to be merged into the stock UCM tree for the speakers and microphone to
# be picked up. Shaped like nixpkgs' `alsa-ucm-conf-asahi`, which solves the
# same problem for Apple silicon.
# https://github.com/deqrocks/t2bce/tree/main/t2bce_audio-alsa-ucm-conf
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  symlinkJoin,
  alsa-ucm-conf,
  nix-update-script,
}:
let
  profiles = stdenvNoCC.mkDerivation {
    pname = "alsa-ucm-conf-t2bce";
    version = "0-unstable-2026-08-10";

    src = fetchFromGitHub {
      owner = "deqrocks";
      repo = "t2bce";
      rev = "a973d53c8278e9db5ff8314b816d6880309ed39e";
      hash = "sha256-uQYwSCqp4kwPL3fYQ9mKfWe565c/O6SPpnEc7sae0x4=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/alsa
      cp -r t2bce_audio-alsa-ucm-conf/ucm2 $out/share/alsa/

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };

    strictDeps = true;
    __structuredAttrs = true;

    meta = {
      description = "ALSA UCM configuration extended with the Apple T2 audio profiles";
      homepage = "https://github.com/deqrocks/t2bce";
      # t2bce ships no LICENSE file; its modules declare GPL-2.0 to the kernel.
      license = [
        alsa-ucm-conf.meta.license
        lib.licenses.gpl2Only
      ];
      maintainers = with lib.maintainers; [ mirkolenz ];
      inherit (alsa-ucm-conf.meta) platforms;
      # Only ever used on a T2 Mac, so keep it out of CI.
      hydraPlatforms = [ ];
    };
  };
in
# t2bce only adds directories of its own, so the two trees merge without
# colliding and the stock configuration does not have to be duplicated.
symlinkJoin {
  # `src` is carried over so that nix-update, which reads it off the attribute
  # it is pointed at, can find the URL behind the join.
  inherit (profiles)
    pname
    version
    src
    passthru
    meta
    ;
  paths = [
    alsa-ucm-conf
    profiles
  ];
}
