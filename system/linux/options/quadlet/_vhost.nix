{
  name,
  lib,
}:
{
  options = with lib; {
    name = mkOption {
      type = with types; str;
      default = name;
    };
    extraNames = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    reverseProxy = mkOption {
      default = { };
      type = types.submodule {
        options = {
          upstreams = mkOption {
            type = with types; listOf str;
            default = [ ];
          };
          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = ''
              Additional lines of configuration appended to the reverse proxy in the automatically generated `Caddyfile`.
            '';
          };
        };
      };
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional lines of configuration appended to the virtual host in the automatically generated `Caddyfile`.
      '';
    };
  };
}
