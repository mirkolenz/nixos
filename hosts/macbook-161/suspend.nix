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
  loginctl = lib.getExe' pkgs.systemd "loginctl";
  udevadm = lib.getExe' pkgs.systemd "udevadm";
  settle = "${udevadm} settle --timeout=15";
  wait = "${udevadm} wait --timeout=15";
  jq = lib.getExe pkgs.jq;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  rfkill = lib.getExe' pkgs.util-linux "rfkill";

  hasNm = config.networking.networkmanager.enable;
  hasTouchBar = config.hardware.apple.touchBar.enable;
  hasPipewire = config.services.pipewire.enable;
  hasThermald = config.services.thermald.enable;

  forEachUser = body: ''
    for username in $(${loginctl} list-users --json=short | ${jq} -r '.[].user'); do
      ${body}
    done
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
      TimeoutStartSec = 30;
      TimeoutStopSec = 60;
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
            if ! ls /sys/bus/pci/drivers/apple-bce/0000:* >/dev/null 2>&1; then
              echo "WARNING: apple-bce did not bind to a PCI device"
            fi
          '';
        };
      };

      # Wi-Fi/Bluetooth: block radios via rfkill, unload/reload Wi-Fi drivers.
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
            ${modprobe} brcmfmac_wcc
            # brcmfmac loads firmware in-kernel (invisible to udev settle).
            # Wait for the network interface to appear instead.
            if ! ${wait} /sys/class/net/wlan0; then
              echo "WARNING: Wi-Fi interface did not appear within 15 s"
            fi
            ${rfkill} unblock wifi
            ${rfkill} unblock bluetooth
            ${lib.optionalString hasNm "${systemctl} start NetworkManager.service"}
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
      # Race condition on resume: apple-bce enumerates USB devices sequentially:
      #   usb 1-6 (Touch Bar Display, 05AC:8302) appears before
      #   usb 1-7 (Touch Bar Backlight, 05AC:8102).
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
            if ! ${wait} /sys/class/leds/:white:kbd_backlight; then
              echo "WARNING: kbd_backlight LED device did not appear within 15 s"
              exit 0
            fi

            ${modprobe} hid_appletb_kbd
            ${settle}

            ${modprobe} appletbdrm
            if ! ${wait} /dev/tiny_dfr_display /dev/tiny_dfr_backlight /dev/tiny_dfr_display_backlight; then
              echo "WARNING: tiny-dfr device nodes did not appear within 15 s"
            fi

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

      # Sets keyboard backlight on boot.
      t2-kbd-backlight = {
        description = "T2 boot: set keyboard backlight";
        wantedBy = [ "multi-user.target" ];
        after = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = mkExecScript "t2-kbd-backlight" ''
            ${brightnessctl} -d :white:kbd_backlight set 50% -q
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
