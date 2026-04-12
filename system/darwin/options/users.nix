{ lib, ... }:
let
  systemUsers = {
    _ollama = 551;
    _llamacpp = 552;
  };
in
{
  ids.uids = systemUsers;
  ids.gids = systemUsers;
  users.knownUsers = lib.attrNames systemUsers;
  users.knownGroups = lib.attrNames systemUsers;
}
