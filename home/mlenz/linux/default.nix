{
  pkgs,
  lib,
  lib',
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  home.packages = with pkgs; [
    fastfetch
    cfspeedtest
    # https://unix.stackexchange.com/a/617686
    (writeShellApplication {
      name = "getusers";
      text = ''
        ${lib.getExe' procps "ps"} -eo user,uid | ${lib.getExe gawk} 'NR>1 && $2 >= 1000 && ++seen[$2]==1{print $1}'
      '';
    })
  ];
}
