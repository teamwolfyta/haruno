{ inputs, pkgs, ... }:
inputs.devenv.lib.mkShell {
  inherit inputs pkgs;

  modules = [
    {
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
          echo "✔️ Updating Nix flake..."
          nix flake update || { echo "❌ Failed to update Nix flake" >&2; exit 1; }

          git diff --quiet flake.lock && { echo "✔️ No changes to flake.lock"; exit 0; }

          (git add flake.lock && git commit -m "chore(flake): Update flake lock") || \
            { echo "❌ Failed to update flake.lock" >&2; exit 1; }

          echo "✔️ flake.lock has been updated and committed"
        '';
      };
    }
  ];
}
