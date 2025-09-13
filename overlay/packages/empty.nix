{ runCommandNoCCLocal }:
runCommandNoCCLocal "empty" { } ''
  mkdir -p $out
''
