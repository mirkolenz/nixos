{
  lib,
  fetchFromGitHub,
  swift,
  swiftPackages,
}:
swiftPackages.stdenv.mkDerivation {
  name = "pam-watchid";
  src = fetchFromGitHub {
    owner = "biscuitehh";
    repo = "pam-watchid";
    rev = "6061b86e96c766085718d4589c974184d86cf1d3";
    hash = "sha256-EJekXScC2Oay2ySb+xT1VusZ265WNh3JjezsbSBSEB4=";
  };
  nativeBuildInputs = [ swift ];
  # requires swift v6
  # src = fetchFromGitHub {
  #   owner = "cdalvaro";
  #   repo = "pam-watchid";
  #   rev = "2a40e98940a5fa2655a88432b7c970d3ebf6fc6a";
  #   hash = "sha256-lp88RXwN/WwIFaFnrG8aNA3HBVWDNCIfUnBLAtcaaHc=";
  # };
  # alternative, but apple sdk v15 requires swift v6 as well
  # buildInputs = [ apple-sdk_15 ];
  # patchPhase = ''
  #   runHook prePatch

  #   substituteInPlace watchid-pam-extension.swift \
  #     --replace-fail \
  #     'return .deviceOwnerAuthenticationWithBiometricsOrWatch' \
  #     'return .deviceOwnerAuthenticationWithBiometricsOrCompanion'

  #   runHook postPatch
  # '';
  buildPhase = ''
    runHook preBuild

    swiftc watchid-pam-extension.swift \
      -o pam_watchid.so \
      -emit-library \
      -Ounchecked

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pam
    cp pam_watchid.so $out/lib/pam

    runHook postInstall
  '';
  meta = with lib; {
    homepage = "https://github.com/biscuitehh/pam-watchid";
    description = "PAM plugin module that allows the Apple Watch to be used for authentication";
    license = licenses.unlicense;
    maintainers = with maintainers; [ mirkolenz ];
    platforms = platforms.darwin;
  };
}
