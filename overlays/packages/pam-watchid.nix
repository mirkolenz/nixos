{
  swift,
  fetchFromGitHub,
  stdenv,
  lib,
}:
stdenv.mkDerivation {
  name = "pam-watchid";
  src = fetchFromGitHub {
    owner = "cdalvaro";
    repo = "pam-watchid";
    rev = "2a40e98940a5fa2655a88432b7c970d3ebf6fc6a";
    hash = "sha256-lp88RXwN/WwIFaFnrG8aNA3HBVWDNCIfUnBLAtcaaHc=";
  };
  nativeBuildInputs = [ swift ];
  meta = with lib; {
    homepage = "https://github.com/cdalvaro/pam-watchid";
    description = "PAM plugin module that allows the Apple Watch to be used for authentication";
    license = licenses.unlicense;
    maintainers = with maintainers; [ mirkolenz ];
    platforms = platforms.darwin;
  };
}
