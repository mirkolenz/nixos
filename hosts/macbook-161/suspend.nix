# https://wiki.t2linux.org/guides/postinstall/#suspend-workaround
# https://github.com/lucadibello/T2Linux-Suspend-Fix
# https://github.com/jobvisser03/jv-nix-config/blob/feature/mrsom3body-dendritic/modules/hosts/macbook-intel-nixos/_t2-suspend/default.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.hardware.apple-t2-suspend;
  modprobe = lib.getExe' pkgs.kmod "modprobe";
  rmmod = lib.getExe' pkgs.kmod "rmmod";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  systemdRun = lib.getExe' pkgs.systemd "systemd-run";
  loginctl = lib.getExe' pkgs.systemd "loginctl";
  udevadm = lib.getExe' pkgs.systemd "udevadm";
  settle = "${udevadm} settle --timeout=15";
  jq = lib.getExe pkgs.jq;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  iw = lib.getExe pkgs.iw;
  rfkill = lib.getExe' pkgs.util-linux "rfkill";
  notifySend = lib.getExe' pkgs.libnotify "notify-send";

  hasNm = config.networking.networkmanager.enable;
  hasIwd = hasNm && config.networking.networkmanager.wifi.backend == "iwd";
  hasTouchBar = config.hardware.apple.touchBar.enable;
  hasPipewire = config.services.pipewire.enable;
  hasThermald = config.services.thermald.enable;

  forEachUser = body: ''
    for username in $(${loginctl} list-users --json=short | ${jq} -r '.[].user'); do
      ${body}
    done
  '';
  withSessionUser = body: ''
    username=$(${loginctl} list-sessions --json=short | ${jq} -r '[.[] | select(.seat == "seat0")] | .[0].user // empty')
    if [ -n "$username" ]; then
      ${body}
    fi
  '';
  notify =
    message:
    withSessionUser ''
      ${systemdRun} --user --machine="$username"@.host --pipe --quiet -- \
        ${notifySend} -a "T2 Suspend" "${message}"
    '';
  mkExecScript =
    name: body:
    pkgs.writeShellScript name ''
      set +e
      ${body}
    '';
  mkSuspendService = lib.recursiveUpdate {
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
in
{
  options.hardware.apple-t2-suspend = {
    enable = lib.mkEnableOption "T2 Mac suspend/resume fixes";
  };

  config = lib.mkIf cfg.enable {
    # Disable PCIe Active State Power Management to prevent suspend instability.
    boot.kernelParams = [ "pcie_aspm=off" ];

    # The official T2 suspend workaround force-unloads apple-bce with rmmod -f during suspend.
    # Enable MODULE_FORCE_UNLOAD explicitly so that workaround is supported by this kernel build.
    boot.kernelPatches = [
      {
        name = "t2-suspend-force-unload";
        patch = null;
        structuredExtraConfig = {
          MODULE_FORCE_UNLOAD = lib.kernel.yes;
        };
      }
    ];

    systemd.sleep.settings.Sleep = {
      SuspendState = "mem";
      MemorySleepMode = "deep";
    };

    systemd.services = {
      # Core: force-unloads apple-bce last on suspend, reloads first on resume.
      # All other suspend-t2-* services are ordered before this one.
      # pm_async=0 disables asynchronous device power management during suspend/resume
      # to prevent race conditions between driver teardown and hardware state changes.
      suspend-t2-apple-bce = mkSuspendService {
        description = "T2 suspend: unload/reload apple-bce";
        after = [
          "suspend-t2-radio.service"
        ]
        ++ lib.optional hasPipewire "suspend-t2-audio.service"
        ++ lib.optional hasTouchBar "suspend-t2-touchbar.service"
        ++ [ "suspend-t2-backlight.service" ]
        ++ lib.optional hasThermald "suspend-t2-thermald.service";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-apple-bce" ''
            ${rmmod} -f apple-bce
            echo 0 > /sys/power/pm_async
          '';
          ExecStop = mkExecScript "resume-t2-apple-bce" ''
            echo 1 > /sys/power/pm_async
            ${modprobe} apple-bce
            ${settle}
            if ! find /sys/bus/pci/drivers/apple-bce -maxdepth 1 -type l -name '*:*' -print -quit 2>/dev/null | grep -q .; then
              ${notify "apple-bce did not initialize within 15 s"}
            fi
          '';
        };
      };

      # Wi-Fi/Bluetooth: block radios via rfkill, unload/reload Wi-Fi drivers.
      # iwd does not re-detect the interface after brcmfmac reload:
      # https://github.com/NixOS/nixpkgs/issues/186274
      suspend-t2-radio = mkSuspendService {
        description = "T2 suspend: block/unblock radios and reload Wi-Fi drivers";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-radio" ''
            ${lib.optionalString hasNm "${systemctl} stop NetworkManager.service"}
            ${rfkill} block wifi
            ${rfkill} block bluetooth
            ${modprobe} -r brcmfmac_wcc
            ${modprobe} -r brcmfmac
          '';
          ExecStop = mkExecScript "resume-t2-radio" ''
            ${modprobe} brcmfmac
            ${settle}
            ${modprobe} brcmfmac_wcc
            ${settle}

            if ! ${iw} dev | grep -q "Interface"; then
              ${modprobe} -r brcmfmac_wcc
              ${modprobe} -r brcmfmac
              ${modprobe} brcmfmac
              ${settle}
              ${modprobe} brcmfmac_wcc
              ${settle}
            fi

            ${rfkill} unblock wifi
            ${rfkill} unblock bluetooth

            if ${iw} dev | grep -q "Interface"; then
              ${lib.optionalString hasIwd "${systemctl} restart iwd.service"}
              ${lib.optionalString hasNm "${systemctl} start NetworkManager.service"}
            else
              ${notify "Wi-Fi interface did not appear after resume"}
            fi
          '';
        };
      };

      # Stop PipeWire before apple-bce removal to prevent kernel panic from stale PCM handles.
      suspend-t2-audio = lib.mkIf hasPipewire (mkSuspendService {
        description = "T2 suspend: stop/start PipeWire audio session";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-audio" (forEachUser ''
            ${systemctl} --user --machine="$username"@.host stop \
              pipewire.socket pipewire-pulse.socket \
              pipewire.service pipewire-pulse.service wireplumber.service
          '');
          ExecStop = mkExecScript "resume-t2-audio" (forEachUser ''
            ${systemctl} --user --machine="$username"@.host start \
              pipewire.socket pipewire-pulse.socket
          '');
        };
      });

      # Touch Bar: stop tiny-dfr and unload/reload kernel modules.
      # udevadm settle only waits for kernel/udev events, not for the DRM framebuffer
      # device to be fully initialized by appletbdrm, so tiny-dfr needs an extra delay.
      suspend-t2-touchbar = lib.mkIf hasTouchBar (mkSuspendService {
        description = "T2 suspend: unload/reload Touch Bar drivers";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-touchbar" ''
            ${systemctl} stop tiny-dfr.service
            ${modprobe} -r appletbdrm
            ${modprobe} -r hid_appletb_kbd
            ${modprobe} -r hid_appletb_bl
          '';
          ExecStop = mkExecScript "resume-t2-touchbar" ''
            ${modprobe} hid_appletb_bl
            ${settle}
            ${modprobe} hid_appletb_kbd
            ${settle}
            ${modprobe} appletbdrm
            ${settle}
            ${lib.getExe' pkgs.coreutils "sleep"} 2
            ${systemctl} start tiny-dfr.service
          '';
        };
      });

      # Keyboard backlight: save and dim before suspend, restore on resume.
      suspend-t2-backlight = mkSuspendService {
        description = "T2 suspend: save/restore keyboard backlight";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-backlight" ''
            ${brightnessctl} -sd :white:kbd_backlight set 0 -q
          '';
          ExecStop = mkExecScript "resume-t2-backlight" ''
            ${brightnessctl} -rd :white:kbd_backlight
          '';
        };
      };

      # Fixes keyboard backlight after boot by waiting for udev to settle once and
      # resetting apple-bce if the backlight device is still missing.
      t2-kbd-backlight = {
        description = "T2 boot: fix keyboard backlight";
        wantedBy = [ "multi-user.target" ];
        after = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = mkExecScript "t2-kbd-backlight" ''
            ${settle}
            if ${brightnessctl} -rd :white:kbd_backlight; then
              exit 0
            fi
            ${rmmod} -f apple-bce
            ${modprobe} apple-bce
            ${settle}
            ${brightnessctl} -rd :white:kbd_backlight
          '';
        };
      };

      # Thermald: stop to prevent interference during suspend.
      suspend-t2-thermald = lib.mkIf hasThermald (mkSuspendService {
        description = "T2 suspend: stop/start thermald";
        serviceConfig = {
          ExecStart = mkExecScript "suspend-t2-thermald" ''
            ${systemctl} stop thermald.service
          '';
          ExecStop = mkExecScript "resume-t2-thermald" ''
            ${systemctl} start thermald.service
          '';
        };
      });
    };
  };
}
