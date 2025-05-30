{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin rec {
  pname = "copilot.vim";
  version = "1.50.0";
  # prefetch-attr .#vimPlugins.copilot-vim.src.url --unpack
  src = fetchFromGitHub {
    owner = "github";
    repo = "copilot.vim";
    tag = "v${version}";
    hash = "sha256-Y0VG+X16yB8gj+g/dCg2OUe1iXc0wGq94jGc3V/Lz7k=";
  };
  meta.homepage = "https://github.com/github/copilot.vim/";
}
