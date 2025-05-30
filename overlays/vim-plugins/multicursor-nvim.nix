{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "multicursor.nvim";
  # prefetch-attr .#vimPlugins.multicursor-nvim.src.url --unpack
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "6fba38bccf45cfb681f4ff6098f886213f299a34";
    hash = "sha256-NUOJlFZhB8OqBlkp+dXUQzFTHvPCMmWFMMTWmV7XdLQ=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
}
