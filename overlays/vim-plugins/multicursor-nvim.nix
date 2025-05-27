{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "multicursor.nvim";
  # prefetch-attr .#vimPlugins.multicursor-nvim.src.url --unpack
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "9eedebdd395bbbc4711081e33b0606c079e054c3";
    hash = "sha256-bCk/b1LKORvgcpQwAGv9foa9fl4TwHN64UEdzlncAi4=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
}
