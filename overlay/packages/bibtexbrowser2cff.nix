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
  meta = bibtexbrowser.meta // {
    platforms = php.meta.platforms;
  };
}
