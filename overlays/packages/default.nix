{ inputs, self, ... }:
final: prev:
let
  inherit (final.stdenv.hostPlatform) system;
  flake-exports = {
    bibtex2cff = final.callPackage ./bibtex2cff.nix { };
    bibtexbrowser = final.callPackage ./bibtexbrowser.nix { };
    bibtexbrowser2cff = final.callPackage ./bibtexbrowser2cff.nix { };
    caddy-docker = final.callPackage ./caddy-docker.nix { };
    custom-caddy = final.caddy.withPlugins {
      plugins = [
        "github.com/caddy-dns/cloudflare@89f16b99c18ef49c8bb470a82f895bce01cbaece"
      ];
      hash = "sha256-43SOmmz/iAvUhbzFZ9THRqsys7/eK6Oo1xVGZcsmZIw=";
    };
    custom-caddy-docker = final.callPackage ./caddy-docker.nix {
      caddy = final.custom-caddy;
    };
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
  inherit (self.packages.${system}) nixvim nixvim-unstable nixvim-stable;
  arguebuf = inputs.arguebuf.packages.${system}.default;
  nixfmt = final.nixfmt-rfc-style;
  dummy = final.writeShellScriptBin "dummy" ":";
  mkApp = final.callPackage ./make-app.nix { };
}
// flake-exports
