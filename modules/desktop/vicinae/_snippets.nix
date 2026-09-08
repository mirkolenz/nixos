# Vicinae snippets, imported by ./default.nix.
# The leading underscore hides this data file from import-tree.
#
# The attribute name is the searchable title, `keyword` triggers the expansion
# anywhere in the system, and `text` is what gets typed in its place.
# Placeholders in `text` (https://docs.vicinae.com/snippets):
# - `{date format="dd.MM.yyyy"}` formats the current date with Qt date tokens.
# - `{clipboard}`, `{uuid}`, and `{cursor}` expand on their own.
# - `{shell code="..."}` runs a command, `{name}` prompts for an argument.
{
  # keep-sorted start block=yes
  "Today" = {
    keyword = ":today";
    text = "{date format=\"dd.MM.yyyy\"}";
  };
  "aarch64-darwin" = {
    keyword = ":ad";
    text = "aarch64-darwin";
  };
  "aarch64-linux" = {
    keyword = ":al";
    text = "aarch64-linux";
  };
  "x86_64-darwin" = {
    keyword = ":xd";
    text = "x86_64-darwin";
  };
  "x86_64-linux" = {
    keyword = ":xl";
    text = "x86_64-linux";
  };
  # keep-sorted end
}
