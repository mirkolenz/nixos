# { lib, pkgs, config, ... }:
# {
#   imports = [
#     ./common
#     ./darwin
#     ./linux
#     ./server
#     ./workstation
#   ];

#   options.custom = {
#     isWorkstation = lib.mkEnableOption "Workstation";
#     isServer = lib.mkEnableOption "Server";
#   };
# }
