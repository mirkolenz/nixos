{
  writeShellApplication,
  bibtexbrowser,
  lib,
  php,
}:
writeShellApplication {
  name = "bibtexbrowser2cff";
  text = ''
    exec ${lib.getExe php} ${bibtexbrowser}/bibtex-to-cff.php "$@"
  '';
  meta = {
    description = "Beautiful publication lists with bibtex and PHP";
    homepage = "www.monperrus.net/martin/bibtexbrowser/";
    downloadPage = "https://github.com/monperrus/bibtexbrowser/commits/master/";
    platforms = with lib.platforms; darwin ++ linux;
    maintainers = with lib.maintainers; [ mirkolenz ];
  };
}
