{ ... }:
{
  opts = {
    shiftwidth = 2;
    tabstop = 2;
    wrap = true;
  };
  keymaps = [
    {
      key = "<leader>tb";
      mode = "n";
      action = "<cmd>TexlabWriteBuild<CR>";
      options.desc = "Write and build the document";
    }
    {
      key = "<leader>tB";
      mode = "n";
      action = "<cmd>TexlabCancelBuild<CR>";
      options.desc = "Cancel the current build";
    }
    {
      key = "<leader>tc";
      mode = "n";
      action = "<cmd>TexlabCleanAuxiliary<CR>";
      options.desc = "Clean auxiliary files";
    }
    {
      key = "<leader>tC";
      mode = "n";
      action = "<cmd>TexlabCleanArtifacts<CR>";
      options.desc = "Clean auxiliary and output files";
    }
  ];
  userCommands = {
    TexlabWriteBuild = {
      command = "write | TexlabBuild";
      desc = "Write and build the document";
    };
  };
}
