{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule
  ];

  perSystem = {pkgs, ...}: {
    pre-commit.settings.hooks = {
      commitlint-rs = {
        enable = true;
        entry = "commitlint --edit .git/COMMIT_EDITMSG";
        language = "system";
        package = pkgs.commitlint-rs;
        pass_filenames = false;
        require_serial = true;
        stages = ["prepare-commit-msg"];
        verbose = true;
      };
      editorconfig-checker.enable = true;
      flake-checker.enable = true;
      treefmt.enable = true;
    };
  };
}
