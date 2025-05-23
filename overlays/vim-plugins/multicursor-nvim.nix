{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  name = "multicursor.nvim";
  # prefetch-attr .#vimPlugins.multicursor-nvim.src.url --unpack
  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "multicursor.nvim";
    rev = "cecbb3028ba166578eb8620ce885e2362d112ee0";
    hash = "sha256-IpLBYcqbM2AqVS4qyijmsYqfsXCcaq1yDpwGXw8Vqqg=";
  };
  meta.homepage = "https://github.com/jake-stewart/multicursor.nvim";
}
