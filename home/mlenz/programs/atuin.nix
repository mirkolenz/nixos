{ ... }:
{
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      update_check = false;
      search_mode = "fuzzy";
      enter_accept = true;
      keymap_mode = "vim-insert";
    };
  };
}
