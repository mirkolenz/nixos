{ ... }:
final: prev: {
  bibtex2cff = final.callPackage ./bibtex2cff.nix { };
  bibtexbrowser = final.callPackage ./bibtexbrowser.nix { };
  bibtexbrowser2cff = final.callPackage ./bibtexbrowser2cff.nix { };
  hkknx-bin = final.callPackage ./hkknx.nix { };
  hkknx-docker = final.callPackage ./hkknx-docker.nix { };
}
