# NixOS Setup

All configurations select the correct device name through their hostname.
When setting up a new host, please run the following first:

```shell
hostname MACHINE_NAME
```

You may also change the hostname as follows:

```shell
nix run github:mirkolenz/nixos -- --hostname MACHINE_NAME
```

## NixOS

### Graphical Setup

1. Install NixOS with provided ISO
2. Create config: `nixos-generate-config`
3. Migrate generated `/etc/nixos/configuration.nix` and `/etc/nixos/hardware-configuration.nix` to this flake manually
4. Eventually install git in a temporary shell: `nix shell nixpkgs#git`

```shell
# Large changes (like first time)
sudo nix run github:mirkolenz/nixos -- -o boot
# Small changes
sudo nix run github:mirkolenz/nixos
```

### Terminal Setup

- https://www.adaltas.com/en/2022/02/08/nixos-installation/
- https://nixos.wiki/wiki/NixOS_Installation_Guide
- https://gist.github.com/Vincibean/baf1b76ca5147449a1a479b5fcc9a222

#### Partitioning using `parted`

```shell
parted -l # find device name, most likely /dev/sda
wipefs -a /dev/sda
parted /dev/sda
mklabel gpt
mkpart boot fat32 0% 512MiB
set 1 esp on
unit GiB print free
# determine the swap size by substractting the amount of your ram from the free size
# for instance, free size here is 238GiB and the ram of the system is 8GiB
mkpart root ext4 512MiB 230GiB
mkpart swap linux-swap 230GiB 100%
```

#### Partitioning using `fdisk`

One can also use the ncurses-based program `cfdisk`.

```shell
# Find out the device name, most likely /dev/sda
fdisk -l # or lsblk
wipefs -a /dev/sda
fdisk /dev/sda
g # empty gpt partition table
n # new partition
1 # partition number
2048 # first sector, default
+512M # last sector
t # change partition type
1 # partition number (if not already selected)
1 # efi partition type
n # new partition
2 # partition number
# first sector, default
-16G # last sector, size of swap (about the size of your ram)
n # new partition
3 # partition number
# first sector, default
# last sector, default
t # change partition type
3 # partition number
19 # linux swap
v # verify
w # write
```

#### Formatting

```shell
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L root /dev/sda2
mkswap -L swap /dev/sda3
```

#### Mounting

```shell
mount /dev/disk/by-label/root /mnt
swapon /dev/disk/by-label/swap
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

#### Installation

If you get an error like `too many open files` during `nixos-install`, try one of the following options:

- Execute `ulimit -n 65535` before installing to increase the number of open files for the current shell session
- Use `--max-jobs 2` to limit the number of parallel jobs (could also try with 1 max job)

```shell
nixos-generate-config --root /mnt
cd /mnt/etc/nixos/
# Now verify that the hardware configuration of this flake is in sync with the generated `hardware-configuration.nix`
# The machine name is required for the nixos-install command, even if hostname is updated
nixos-install --flake github:mirkolenz/nixos#MACHINE_NAME
# One could append --no-root-passwd to the command, but that may affect the ability to enter emergency mode
```

A warning about `/boot` being world-readable is not an issue, [the permissions are correctly set after a reboot](https://discourse.nixos.org/t/nixos-install-with-custom-flake-results-in-boot-being-world-accessible/34555).

### Troubleshooting

If getting an error like `Getting status of /nix/store/...: No such file or directory`, try the following

```shell
nix-store --verify --check-contents --repair
```

## Mac Computers

### Installation

1. `xcode-select --install`
2. [Homebrew](https://brew.sh)
3. [Nix](https://github.com/DeterminateSystems/nix-installer)
4. Enable Full Disk Access for terminal application

```shell
# First invokation
nix run github:mirkolenz/nixos
# You could get the following error: error: Directory /run does not exist, aborting activation
# You need to run apfs.util with sudo, otherwise you will get this error:
# failed to stitch firmlinks and/or create synthetics for root volume (c00d) ...
# You may need to manually remove some existing files like the following
# ATTENTION: Do not close the shell before rebuilding again, otherwise your path may be broken
sudo rm /etc/bashrc /etc/shells /etc/zshrc /etc/nix/nix.conf
# Activate again
nix run github:mirkolenz/nixos
chsh -s /run/current-system/sw/bin/fish
sudo reboot
# Add all ssh keys to keychain
ssh-add --apple-load-keychain ~/.ssh/KEY_NAME
```

### Uninstallation

```shell
chsh -s /bin/zsh
# todo: uninstall home-manager first
nix run github:lnl7/nix-darwin#darwin-uninstaller
/nix/nix-installer uninstall
```

## Home-Manger Standalone

_Note:_ Reconnect via SSH after installing nix.

```shell
sudo /nix/var/nix/profiles/default/bin/nix upgrade-nix
nix run github:mirkolenz/nixos#home
sudo usermod -s $(which fish) "$USER"
```

## Utilities and Snippets

### NixOS Generators

- If building for another architecture on NixOS: [Enable cross compiling](https://github.com/nix-community/nixos-generators#cross-compiling)
- Available formats:
  - `installer-iso`
  - `installer-raspi`

```shell
nix build github:mirkolenz/nixos#FORMAT --system SYSTEM
```

### Update Raspberry Pi

https://nix.dev/tutorials/installing-nixos-on-a-raspberry-pi#updating-firmware

```shell
nix shell pkgs#raspberrypi-eeprom
sudo mount /dev/disk/by-label/FIRMWARE /mnt
sudo env BOOTFS=/mnt FIRMWARE_RELEASE_STATUS=default rpi-eeprom-update -d -a
sudo reboot
```

### Use MakeMKV

```shell
# otherwise the optical drive is not found: https://discourse.nixos.org/t/makemkv-cant-find-my-usb-blu-ray-drive/23714
sudo modprobe sg
# if that does not work, try again with sudo
NIXPKGS_ALLOW_UNFREE=1 nix run pkgs#makemkv --impure
```

### Investigate ID Mappings

```shell
sudo podman run --rm --subuidname=$USER ubuntu cat /proc/self/uid_map
```
