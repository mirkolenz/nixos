{ runCommandLocal }:
runCommandLocal "empty" { } ''
  mkdir -p $out
''
