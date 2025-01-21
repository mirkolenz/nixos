{
  inputs,
  lib,
  self,
  ...
}:
{
  flake = {
    githubActionsBuild = inputs.nix-github-actions.lib.mkGithubMatrix {
      inherit (self) checks;
    };
    githubActionsEval = inputs.nix-github-actions.lib.mkGithubMatrix {
      checks.x86_64-linux =
        { }
        // (lib.mapAttrs (_: module: module.config.system.toplevel.build) self.nixosConfigurations)
        // (lib.mapAttrs (_: module: module.config.system.toplevel.build) self.darwinConfigurations)
        // (lib.mapAttrs (_: module: module.activationPackage) self.homeConfigurations);
    };
  };
}
