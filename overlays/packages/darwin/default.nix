# https://github.com/jwiegley/nix-config/blob/master/overlays/30-apps.nix
# https://cmacr.ae/blog/managing-firefox-on-macos-with-nix/
{ ... }:
final: prev: {
  neovide-bin = final.callPackage ./neovide.nix { };
  vimr-bin = final.callPackage ./vimr.nix { };
  restic-browser-bin = final.callPackage ./restic-browser.nix { };
}
