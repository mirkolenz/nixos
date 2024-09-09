{
  writeShellApplication,
  fetchFromGitHub,
  lib,
  php,
}:
let
  src = fetchFromGitHub {
    owner = "monperrus";
    repo = "bibtexbrowser";
    rev = "4ed89551b58e029407e6d4ba3c8b3b9d1b9c19c9";
    hash = "sha256-91w40g0NHbPvArQQ11FISUfpsmKZ7yyXL26oPqVze7o=";
  };
in
writeShellApplication {
  name = "bibtexbrowser2cff";
  text = ''
    exec ${lib.getExe php} ${src}/bibtex-to-cff.php "$@"
  '';
  meta = {
    description = "Beautiful publication lists with bibtex and PHP";
    homepage = "www.monperrus.net/martin/bibtexbrowser/";
    downloadPage = "https://github.com/monperrus/bibtexbrowser/commits/master/";
    platforms = with lib.platforms; darwin ++ linux;
    maintainers = with lib.maintainers; [ mirkolenz ];
  };
}
