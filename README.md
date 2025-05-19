<!-- markdownlint-disable MD033 -->

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

- <https://www.adaltas.com/en/2022/02/08/nixos-installation/>
- <https://nixos.wiki/wiki/NixOS_Installation_Guide>
- <https://gist.github.com/Vincibean/baf1b76ca5147449a1a479b5fcc9a222>

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

### Tailscale

- Create auth key: <https://login.tailscale.com/admin/settings/keys>
- SSH into the machine
- Save the auth key to `./tsauth.txt`
- Run `sudo tailscale up --auth-key file:tsauth.txt`
- Run `tailscale status` to verify the connection
- Remove the auth key file: `rm ./tsauth.txt`
- Approve exit-node/routes: <https://login.tailscale.com/admin/machines>

## Mac Computers

### Installation

1. Install Apple Developer Tools: `xcode-select --install`
2. [Install Homebrew](https://brew.sh)
3. [Install Nix](https://docs.determinate.systems/getting-started/)
4. Sign in to the App Store
5. Enable Full Disk Access for terminal application

Make sure to exclude the Nix volume from Time Machine and Spotlight:

- `General > Time Machine > Options > Exclude from Backups`: Add `/nix`
- `Spotlight > Search Privacy`: Add `/nix`

```shell
sudo nix --extra-experimental-features "nix-command flakes" run github:mirkolenz/nixos
sudo reboot
# Add ssh key to keychain
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

### Uninstallation

```shell
sudo /nix/var/nix/profiles/default/bin/nix run github:mirkolenz/nixos#darwin-uninstaller
sudo /nix/nix-installer uninstall
```

### Applications and Settings

<details>
<summary>System Preferences</summary>

- `General > About`: Set name
- `Wallpaper`: Solid color (black)
- `Appearance > Allow wallpaper tinting in windows`: Off
- `Keyboard > Keyboard Shortcuts > Modifier Keys`: Caps Lock -> Option
- `Keyboard > Keyboard Shortcuts > App Shortcuts`: Disable all
- `Keyboard > Keyboard Shortcuts > Spotlight`: Disable all

</details>

<details>
<summary>Raycast</summary>

- `Settings > Advanced > Import/Export` (also set up new schedule)
- `Settings > Account > Login`
- `Settings > Extensions > Scripts > Plus`: iCloud Drive
- `Launch > Manage Fallback Command`: Add Kagi

</details>

<details>
<summary>Visual Studio Code</summary>

- `Settings > Backup and Sync Setting > GitHub`

</details>

<details>
<summary>Zotero</summary>

- [Install Better BibTeX](https://github.com/retorquere/zotero-better-bibtex)
- `Settings > General > Customize Filename Format > {{ creators max="1" case="hyphen" }}-{{ year }}-{{ title truncate="50" case="hyphen" }}`
- `Settings General > Reader > Tabs > Creator - Title - Year`
- `Settings > Export > Item Format > Better BibTeX Citation Key Quick Copy`
- `Settings > Export > Note Format > Markdown + Rich Text`
- `Settings > Better BibTeX > Citation Key Format > auth.capitalize + year + shorttitle(3,3)`
- `Settings > Better BibTeX > Citation Key Format > Automatic Export > Delay > 10 seconds`

</details>

<details>
<summary>Default Folder X</summary>

- `Settings > Options > Sync settings via iCloud`

</details>

<details>
<summary>iA Presenter</summary>

- Move theme to `$HOME/Library/Containers/net.ia.presenter/Data/Library/Application Support/iA Presenter/Themes`

</details>

<details>
<summary>Arq Backup</summary>

Additional wildcard exclude rules:

```txt
.venv
.direnv
.devenv
node_modules
*/OrbStack
*/.orbstack
*/Library/CloudStorage
*/Library/Application Support/
```

</details>

## Home-Manger Standalone

_Note:_ Reconnect via SSH after installing nix.

```shell
sudo /nix/var/nix/profiles/default/bin/nix upgrade-nix
nix run github:mirkolenz/nixos
sudo usermod -s $(which fish) "$USER"
```

## Utilities and Snippets

### Nix Access Tokens

To avoid rate limiting, add a [GitHub access token](https://nix.dev/manual/nix/stable/command-ref/conf-file.html#conf-access-tokens).
Add the following to `/etc/nix/nix.local.conf`:

```ini
access-tokens = github.com=github_pat_XXX
```

### Image Building

If building for another architecture on NixOS:
[Enable cross compiling](https://github.com/nix-community/nixos-generators#cross-compiling)

```shell
# for iso installer disc
nix build --system x86_64-linux github:mirkolenz/nixos#installers.unstable.iso-installer
# for raspberry pi sd card
nix build --system aarch64-linux github:mirkolenz/nixos#installers.raspi
```

### Update Raspberry Pi

<https://nix.dev/tutorials/installing-nixos-on-a-raspberry-pi#updating-firmware>

```shell
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
