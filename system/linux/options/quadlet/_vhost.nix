{
  name,
  lib,
  ...
}:
{
  options = {
    name = lib.mkOption {
      type = with lib.types; str;
      default = name;
    };
    extraNames = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
    };
    reverseProxy = lib.mkOption {
      default = { };
      type = lib.types.submodule {
        options = {
          upstreams = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
          };
          extraConfig = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = ''
              Additional lines of configuration appended to the reverse proxy in the automatically generated `Caddyfile`.
            '';
          };
        };
      };
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Additional lines of configuration appended to the virtual host in the automatically generated `Caddyfile`.
      '';
    };
  };
}
