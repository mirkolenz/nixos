{ inputs, self, ... }:
final: prev:
let
  inherit (final.stdenv.hostPlatform) system;
  flake-exports = {
    bibtex2cff = final.callPackage ./bibtex2cff.nix { };
    bibtexbrowser = final.callPackage ./bibtexbrowser.nix { };
    bibtexbrowser2cff = final.callPackage ./bibtexbrowser2cff.nix { };
    caddy-custom = final.callPackage ./caddy-custom.nix { };
    caddy-custom-docker = final.callPackage ./caddy-docker.nix { caddy = final.caddy-custom; };
    caddy-docker = final.callPackage ./caddy-docker.nix { };
    goneovim-bin = final.callPackage ./goneovim.nix { };
    hkknx-bin = final.callPackage ./hkknx.nix { };
    hkknx-docker = final.callPackage ./hkknx-docker.nix { };
    neohtop-bin = final.callPackage ./neohtop.nix { };
    neovide-bin = final.callPackage ./neovide.nix { };
    pam-watchid = final.callPackage ./pam-watchid.nix { };
    restic-browser-bin = final.callPackage ./restic-browser.nix { };
    vimr-bin = final.callPackage ./vimr.nix { };
    zigstar-multitool = final.callPackage ./zigstar-multitool.nix { };
  };
in
{
  inherit flake-exports;
  inherit (self.packages.${system})
    nixvim
    nixvim-unstable
    nixvim-stable
    treefmt-nix
    ;
  inherit (inputs.arguebuf.packages.${system}) arguebuf;
  inherit (inputs.uv2nix.packages.${system}) uv-bin;
  nixfmt = final.nixfmt-rfc-style;
  dummy = final.writeShellScriptBin "dummy" ":";
  mkApp = final.callPackage ./make-app.nix { };
  caddy = final.nixpkgs.caddy;
}
// flake-exports
