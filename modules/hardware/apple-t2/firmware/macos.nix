# Reads the firmware out of the macOS install that shares the disk. Doing that
# at runtime keeps the blobs out of both this repo and the nix store.
# https://wiki.t2linux.org/guides/wifi-bluetooth/ (method 4)
{
  flake.modules.nixos.apple-t2 =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.custom.apple-t2.firmware;

      # The kernel searches /lib/firmware unconditionally, which is what makes a
      # runtime drop-off work at all: `firmware_class.path`, the mechanism
      # `hardware.firmware` drives, can only ever point into the store.
      firmwareRoot = "/lib/firmware";

      extract = pkgs.writeShellApplication {
        name = "apple-t2-firmware";
        runtimeInputs = [
          # `get-wifi` and `get-bluetooth`, which map Apple's per-board layout
          # onto the names the drivers ask for, including the clm_blob that
          # carries the 5GHz channel list.
          pkgs.asahi-firmware
          pkgs.coreutils
          pkgs.gnutar
          pkgs.kmod
          pkgs.util-linux
        ];
        text = ''
          work=$(mktemp -d)
          trap 'umount "$work/macos" 2>/dev/null || true; rm -rf "$work"' EXIT
          mkdir -p "$work"/{macos,boards,wifi,bluetooth}
          firmware=$work/macos/usr/share/firmware

          modprobe apfs

          # Neither coordinate is fixed: a Mac can carry more than one APFS
          # container, and the firmware sits on the system volume, whose index
          # within a container varies. Probe both until the tree turns up.
          while read -r container; do
            for index in {0..5}; do
              mount -t apfs -o "ro,vol=$index" "$container" "$work/macos" 2>/dev/null || continue
              if [ -d "$firmware" ]; then
                break 2
              fi
              umount "$work/macos"
            done
          done < <(blkid -t TYPE=apfs -o device)

          if [ ! -d "$firmware" ]; then
            echo "no APFS volume carries firmware, is macOS still installed?" >&2
            exit 1
          fi

          # Upstream targets Apple Silicon and asserts on any board name it
          # cannot parse, so hand it the T2 boards and nothing else.
          for board in C-4355__s-C1 C-4364__s-B2 C-4364__s-B3 C-4377__s-B3; do
            if [ -d "$firmware/wifi/$board" ]; then
              cp -rs "$firmware/wifi/$board" "$work/boards/"
            fi
          done

          get-wifi "$work/boards" "$work/wifi"
          get-bluetooth "$firmware/bluetooth" "$work/bluetooth"

          # Both tarballs are rooted at brcm/ and use hardlinks for the files
          # Apple ships more than once, so unpack rather than copy.
          mkdir -p ${firmwareRoot}
          for kind in wifi bluetooth; do
            tar -xf "$work/$kind/firmware.tar" -C ${firmwareRoot}
          done
        '';
      };
    in
    # To pick up a macOS upgrade:
    #   rm -rf ${firmwareRoot}/brcm && systemctl start apple-t2-firmware
    lib.mkIf (cfg.enable && cfg.source == "macos") {
      systemd.services.apple-t2-firmware = {
        description = "Extract Broadcom firmware from the macOS install";
        wantedBy = [ "multi-user.target" ];
        # Later boots find the blobs directly, so this runs on the first. The
        # condition names the directory the run creates rather than a file
        # within it, so a board that ships no `.trx` cannot leave the unit
        # firing, and reloading the drivers, on every single boot.
        unitConfig.ConditionPathExists = "!${firmwareRoot}/brcm";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = lib.getExe extract;
          # Firmware landing after the drivers probed does nothing until they
          # are asked again. Failure here only means a reboot is needed.
          ExecStartPost = map (args: "-${pkgs.kmod}/bin/modprobe ${args}") [
            "-r brcmfmac"
            "brcmfmac"
            "-r hci_bcm4377"
            "hci_bcm4377"
          ];
        };
      };
    };
}
