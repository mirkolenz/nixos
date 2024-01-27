{
  self,
  inputs,
  lib',
  ...
}:
{
  _module.args = {
    # available during import
    specialModuleArgs = {
      inherit self inputs lib';
    };

    # can be overriden in module
    moduleArgs = {
      stateVersion = "23.11";
      stateVersionDarwin = 4;
      user = {
        name = "Mirko Lenz";
        mail = "mirko@mirkolenz.com";
        login = "mlenz";
        id = 1000;
        sshKeys = lib'.flocken.githubSshKeys {
          user = "mirkolenz";
          sha256 = "0f52mwv3ja24q1nz65aig8id2cpvnm0w92f9xdc80xn3qg3ji374";
        };
      };
    };
  };
}
