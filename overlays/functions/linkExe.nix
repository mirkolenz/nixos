{ writeShellApplication, lib }:
{
  name,
  package,
  directory,
}:
writeShellApplication {
  name = "link-${name}";
  text = ''
    ln -snf "$@" ${lib.getExe package} "${directory}/${name}"
  '';
}
