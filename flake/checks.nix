{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      checks.default = inputs.git-hooks.lib.${system}.run {
        src = ../.;

        hooks = {
          commitlint-rs = {
            enable = true;
            entry = "commitlint --edit .git/COMMIT_EDITMSG";
            language = "system";
            package = pkgs.commitlint-rs;
            pass_filenames = false;
            require_serial = true;
            stages = [ "prepare-commit-msg" ];
            verbose = true;
          };
          deadnix.enable = true;
          editorconfig-checker.enable = true;
          flake-checker.enable = true;
          statix.enable = true;
          nixfmt-rfc-style.enable = true;
        };
      };
    };
}
