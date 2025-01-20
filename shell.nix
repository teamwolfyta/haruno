{ inputs, channels }:
let
  pkgs = channels.nixpkgs;
in
inputs.devenv.lib.mkShell {
  inherit inputs pkgs;

  modules = [
    (_: {
      languages = {
        nix.enable = true;
        shell.enable = true;
      };

      pre-commit.hooks = {
        commitlint-rs = {
          enable = true;
          entry = "commitlint --edit .git/COMMIT_EDITMSG";
          language = "rust";
          package = pkgs.commitlint-rs;
          pass_filenames = false;
          stages = [ "commit-msg" ];
        };
        deadnix.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        statix.enable = true;
        nixfmt-rfc-style.enable = true;
      };

      scripts = {
        "update-flake-lock".exec = ''
          nix flake update

          if git diff --quiet flake.lock; then
              echo "No changes to flake.lock"
          else
              # Stage flake.lock changes
              git add flake.lock

              # Commit the changes
              git commit -m "chore(flake): Update flake lock"

              echo "flake.lock has been updated and committed."
          fi
        '';
      };
    })
  ];
}
