{...}: {
  programs.micro = {
    enable = true;
    settings = {
      autoclose = true;
      autoindent = true;
      autosave = 0;
      backup = true;
      basename = false;
      colorcolumn = 0;
      colorscheme = "monokai";
      comment = true;
      cursorline = true;
      diff = true;
      diffgutter = false;
      encoding = "utf-8";
      eofnewline = true;
      fastdirty = true;
      fileformat = "unix";
      filetype = "unknown";
      ftoptions = true;
      hidehelp = false;
      ignorecase = false;
      indentchar = " ";
      infobar = true;
      keepautoindent = false;
      keymenu = false;
      linter = true;
      literate = true;
      matchbrace = false;
      matchbraceleft = false;
      mkparents = false;
      mouse = true;
      paste = false;
      pluginchannels = [
        "https://raw.githubusercontent.com/micro-editor/plugin-channel/master/channel.json"
      ];
      pluginrepos = [];
      readonly = false;
      rmtrailingws = false;
      ruler = true;
      savecursor = false;
      savehistory = true;
      saveundo = false;
      scrollbar = false;
      scrollmargin = 3;
      scrollspeed = 2;
      smartpaste = true;
      softwrap = false;
      splitbottom = true;
      splitright = true;
      status = true;
      statusformatl = "$(filename) $(modified)($(line),$(col)) $(status.paste)| ft:$(opt:filetype) | $(opt:fileformat) | $(opt:encoding)";
      statusformatr = "$(bind:ToggleKeyMenu): bindings, $(bind:ToggleHelp): help";
      statusline = true;
      sucmd = "sudo";
      syntax = true;
      tabmovement = false;
      tabsize = 4;
      tabstospaces = false;
      termtitle = false;
      useprimary = true;
    };
  };
}
