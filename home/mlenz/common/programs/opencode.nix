{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.custom.profile.isWorkstation {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode-bin;
    # https://opencode.ai/docs/config/
    settings = {
      share = "disabled";
      autoupdate = false;
      model = "lmstudio/openai/gpt-oss-20b";
      provider = {
        lmstudio = {
          npm = "@ai-sdk/openai-compatible";
          name = "LM Studio";
          options.baseURL = "http://127.0.0.1:1234/v1";
          models = {
            "openai/gpt-oss-20b" = {
              name = "GPT-OSS";
            };
            "qwen/qwen3-32b" = {
              name = "Qwen3";
            };
          };
        };
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options.baseURL = "http://127.0.0.1:11434/v1";
          models = { };
        };
      };
    };
  };
  home.sessionVariables = {
    OPENCODE_EXPERIMENTAL = "1";
  };
}
