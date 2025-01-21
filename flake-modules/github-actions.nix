{
  inputs,
  lib,
  self,
  ...
}:
let
  buildChecks = self.checks;
  evalChecks = {
    x86_64-linux =
      { }
      // (lib.mapAttrs (_: module: module.config.system.toplevel.build) self.nixosConfigurations)
      // (lib.mapAttrs (_: module: module.config.system.toplevel.build) self.darwinConfigurations)
      // (lib.mapAttrs (_: module: module.activationPackage) self.homeConfigurations);
  };
  allChecks = lib.recursiveUpdate evalChecks buildChecks;
  filterChecks = checks: lib.getAttrs [ "x86_64-linux" ] checks;
in
{
  flake = {
    githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
      checks = filterChecks allChecks;
    };
    githubActionsBuild = inputs.nix-github-actions.lib.mkGithubMatrix {
      checks = filterChecks buildChecks;
    };
    githubActionsEval = inputs.nix-github-actions.lib.mkGithubMatrix {
      checks = filterChecks evalChecks;
    };
  };
}
