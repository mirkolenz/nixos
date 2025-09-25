{
  modulesPath,
  user,
  lib,
  lib',
  ...
}:
let
  zedSettings = /Users/${user.login}/.config/zed/settings.json;
in
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/lxc-instance-common.nix
  imports = [
    ./hardware.nix
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

  # /etc/nixos/configuration.nix
  security.sudo.wheelNeedsPassword = false;

  # This being `true` leads to a few nasty bugs, change at your own risk!
  users.mutableUsers = lib.mkForce false;

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  users.groups.orbstack.gid = 67278;

  users.users.${user.login} = {
    uid = 501;
    extraGroups = [
      "wheel"
      "orbstack"
    ];

    # simulate isNormalUser, but UID < 1000
    isNormalUser = lib.mkForce false;
    isSystemUser = true;
    group = lib.mkForce "users";
    createHome = true;
    home = "/home/mlenz";
    homeMode = "700";
    useDefaultShell = true;
  };

  # Extra certificates from OrbStack.
  security.pki.certificateFiles = lib'.flocken.optionalPath /opt/orbstack-guest/run/extra-certs.crt;
}
