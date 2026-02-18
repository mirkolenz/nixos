<!-- markdownlint-disable MD033 -->

# Nix Setup

This repo contains a custom wrapper to build NixOS/nix-darwin/home-manager:

```shell
nix run github:mirkolenz/nixos -- --wrapper-help
```

## NixOS Computers

### Initial Setup

- <https://www.adaltas.com/en/2022/02/08/nixos-installation/>
- <https://wiki.nixos.org/wiki/NixOS_Installation_Guide>
- <https://gist.github.com/Vincibean/baf1b76ca5147449a1a479b5fcc9a222>

#### Partitioning

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
# Set up user passwords before installing (see Password Hashing section)
nix run github:mirkolenz/nixos#nixos-install -- MACHINE_NAME
```

A warning about `/boot` being world-readable is not an issue, [the permissions are correctly set after a reboot](https://discourse.nixos.org/t/nixos-install-with-custom-flake-results-in-boot-being-world-accessible/34555).

### Disko Terminal Setup

- <https://github.com/nix-community/disko/blob/master/docs/quickstart.md>
- <https://github.com/nix-community/disko/blob/master/docs/reference.md>

```shell
nix run github:mirkolenz/nixos#disko -- MACHINE_NAME --mode destroy,format,mount
nixos-generate-config --no-filesystems --root /mnt
# verify config as above
# Set up user passwords before installing (see Password Hashing section)
nix run github:mirkolenz/nixos#nixos-install -- MACHINE_NAME
```

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
2. [Install Homebrew](https://github.com/Homebrew/brew/releases/latest)
3. [Install Nix](https://docs.determinate.systems)
4. Sign into the App Store
5. Enable Full Disk Access for terminal application

```shell
sudo nix run github:mirkolenz/nixos
sudo reboot
# Add ssh key to keychain
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

### Uninstallation

```shell
chsh -s /bin/zsh
# if nix is not in PATH, use this: /nix/var/nix/profiles/default/bin/nix
sudo nix run github:mirkolenz/nixos#darwin-uninstaller
sudo /nix/nix-installer uninstall
```

### Applications and Settings

<details>
<summary>Shell</summary>

- Copy `$HOME/.local/share/fish/fish_history`
- Copy `$HOME/.ssh/id_ed25519`

</details>
<details>

<summary>Zed</summary>

- Copy keymap/settings/tasks from `$HOME/.config/zed`

</details>

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

- Install [Better BibTeX](https://github.com/retorquere/zotero-better-bibtex/releases)
- Install [Open PDF](https://github.com/retorquere/zotero-open-pdf/releases)
- `Settings > General > Customize Filename Format > {{ creators max="1" case="hyphen" }}-{{ year }}-{{ title truncate="50" case="hyphen" }}`
- `Settings General > Reader > Tabs > Creator - Title - Year`
- `Settings > Export > Item Format > Better BibTeX Citation Key Quick Copy`
- `Settings > Export > Note Format > Markdown + Rich Text`
- `Settings > Better BibTeX > Citation Key Format > auth.capitalize + year + shorttitle(3,3)`
- `Settings > Better BibTeX > Citation Key Format > Automatic Export > Delay > 10 seconds`
- `Settings > Better BibTeX > Fields > Omit > file, keywords`

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
.cache
.devenv
.direnv
.orbstack
.venv
node_modules
*/OrbStack
*/Library/CloudStorage
*/Library/Application Support/
```

</details>

## Home-Manger Standalone

_Note:_ Reconnect via SSH after installing nix.

```shell
ssh-copy-id -i "$HOME/.ssh/id_ed25519.pub" "USER@MACHINE_NAME"
sudo /nix/var/nix/profiles/default/bin/nix upgrade-nix
nix run github:mirkolenz/nixos
sudo usermod -s $(which fish) "$USER"
```

## Utilities and Snippets

### Nix Access Tokens

To avoid rate limiting, add a [GitHub access token](https://nix.dev/manual/nix/stable/command-ref/conf-file.html#conf-access-tokens).
Add the following to `/etc/nix/nix.secrets.conf`:

```ini
access-tokens = github.com=github_pat_XXX
```

### Image Building

If building for another architecture on NixOS:
[Enable cross compiling](https://github.com/nix-community/nixos-generators#cross-compiling)

```shell
# for iso installer disc
nix build github:mirkolenz/nixos#.legacyPackages.x86_64-linux.installer-default.iso-installer
# for raspberry pi sd card
nix build github:mirkolenz/nixos#.legacyPackages.aarch64-linux.installer-raspi.sd-card
# for apple t2
nix build github:mirkolenz/nixos#.legacyPackages.x86_64-linux.installer-apple-t2.iso-installer
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
nix run github:mirkolenz/nixos#makemkv
```

### Investigate ID Mappings

```shell
sudo podman run --rm --subuidname=$USER ubuntu cat /proc/self/uid_map
```

### Password Hashing

```shell
(umask 077 && mkdir -p /etc/nixos/secrets)
(umask 077 && mkpasswd -m yescrypt > /etc/nixos/secrets/USER.passwd)
```
