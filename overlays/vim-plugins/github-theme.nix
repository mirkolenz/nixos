{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin rec {
  pname = "github-theme";
  version = "1.1.2";
  src = fetchFromGitHub {
    owner = "projekt0n";
    repo = "github-nvim-theme";
    tag = "v${version}";
    hash = "sha256-ur/65NtB8fY0acTUN/Xw9fT813UiL3YcP4+IwkaUzTE=";
  };
}
