{ ... }:
{
  autoCmd = [
    {
      command = "startinsert";
      event = "TermOpen";
      pattern = "term://*";
      desc = "Start terminal in insert mode";
    }
    {
      command = "stopinsert";
      event = "TermClose";
      pattern = "term://*";
      desc = "Switch to normal when closing terminal";
    }
  ];
}
