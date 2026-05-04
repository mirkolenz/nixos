{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    ;

  tomlFormat = pkgs.formats.toml { };

  cfg = config.programs.op;
in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options.programs.op = {
    enable = mkEnableOption "1password";

    package = mkPackageOption pkgs "_1password-cli" { nullable = true; };

    sshAgent = {
      enable = mkEnableOption "1password ssh agent";
      socket = mkOption {
        type = lib.types.str;
        default =
          if pkgs.stdenv.hostPlatform.isDarwin then
            "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          else
            "~/.1password/agent.sock";
        description = ''
          Value used verbatim as `IdentityAgent` in the user's SSH config.
        '';
      };
      settings = mkOption {
        type = tomlFormat.type;
        default = { };
        description = ''
          Configuration written to
          {file}`$XDG_CONFIG_HOME/1password/ssh/agent.toml`.
          See <https://developer.1password.com/docs/ssh/agent/config>
          for more information.
        '';
      };
    };
  };

  #
  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    programs.ssh = lib.mkIf cfg.sshAgent.enable {
      includes = [
        "~/.ssh/1password/config"
      ];
      matchBlocks."*".identityAgent = ''"${cfg.sshAgent.socket}"'';
    };

    xdg.configFile."1password/ssh/agent.toml" = lib.mkIf cfg.sshAgent.enable {
      source = tomlFormat.generate "1password-ssh-agent.toml" cfg.sshAgent.settings;
    };
  };
}
