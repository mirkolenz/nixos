{ ... }:
{
  programs.atuin = {
    enable = true;
    # https://docs.atuin.sh/configuration/config/
    settings = {
      auto_sync = true;
      sync_frequency = "1h";
      update_check = false;
      search_mode = "fuzzy";
      enter_accept = true;
      keymap_mode = "vim-insert";
      sync.records = true;
      dotfiles.enabled = false;
    };
  };
}
