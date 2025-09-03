{
  modulesPath,
  user,
  lib,
  ...
}:
let
  zedSettings = /Users/${user.login}/.config/zed/settings.json;
in
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/lxc-instance-common.nix

  imports = [
    ./hardware.nix
    ./configuration.nix
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  custom.impureRebuild = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.trusted-users = [ user.login ];

  home-manager.users.${user.login} = {
    programs.claude-code.enable = true;
    programs.codex.enable = true;
    services.vscode-server.enable = true;
    xdg.configFile."zed/settings.json" = lib.mkIf (lib.pathExists zedSettings) {
      source = zedSettings;
    };
  };
}
