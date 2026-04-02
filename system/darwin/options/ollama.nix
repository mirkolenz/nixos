{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ollama;
  inherit (lib) types;
in
{
  options = {
    services.ollama = {
      enable = lib.mkEnableOption "Ollama Daemon";

      package = lib.mkOption {
        type = types.package;
        default = pkgs.ollama;
        description = "This option specifies the ollama package to use.";
      };

      host = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = ''
          The host address which the ollama server HTTP interface listens to.
        '';
      };

      port = lib.mkOption {
        type = types.port;
        default = 11434;
        example = 11111;
        description = ''
          Which port the ollama server listens to.
        '';
      };

      models = lib.mkOption {
        type = types.str;
        default = "$HOME/.ollama/models";
        description = ''
          The directory that the ollama service will read models from and download new models to.
        '';
      };

      logs = lib.mkOption {
        type = types.str;
        default = "$HOME/.ollama/logs";
        description = ''
          The directory that the ollama service will write logs to.
        '';
      };

      environmentVariables = lib.mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          OLLAMA_LLM_LIBRARY = "cpu";
          HIP_VISIBLE_DEVICES = "0,1";
        };
        description = ''
          Set arbitrary environment variables for the ollama service.

          Be aware that these are only seen by the ollama server (launchd daemon),
          not normal invocations like `ollama run`.
          Since `ollama run` is mostly a shell around the ollama server, this is usually sufficient.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.ollama = {
      script = ''
        export OLLAMA_MODELS="${cfg.models}"
        exec ${lib.getExe cfg.package} serve >> "${cfg.logs}/server.log" 2>&1
      '';
      environment = cfg.environmentVariables // {
        OLLAMA_HOST = "${cfg.host}:${toString cfg.port}";
      };
      managedBy = "services.ollama.enable";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
