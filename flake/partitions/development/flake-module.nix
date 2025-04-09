{
  config,
  inputs,
  lib,
  ...
}: {
  imports = with inputs; [
    git-hooks.flakeModule
    treefmt-nix.flakeModule
  ];

  systems = ["x86_64-linux"];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    treefmt.programs = {
      actionlint.enable = true;
      alejandra.enable = true;
      deadnix.enable = true;
      jsonfmt.enable = true;
      mdformat.enable = true;
      statix.enable = true;
      yamlfmt.enable = true;
    };

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
      treefmt.enable = true;
    };

    devShells.default = let
      inherit (config) pre-commit treefmt;
    in
      pkgs.mkShellNoCC {
        inputsFrom = [pre-commit.devShell treefmt.build.devShell];

        nativeBuildInputs = with pkgs; [
          nil
        ];

        shellHook = ''
          FLAKE_ROOT=$(${lib.getExe pkgs.gitMinimal} rev-parse --show-toplevel)
          SYMLINK_SOURCE_PATH="${treefmt.build.configFile}"
          SYMLINK_TARGET_PATH="$FLAKE_ROOT/.treefmt.toml"

          if [[ -e "$SYMLINK_TARGET_PATH" && ! -L "$SYMLINK_TARGET_PATH" ]]; then
            echo "treefmt-nix: Error: Target exists but is not a symlink."
            exit 1
          fi

          if [[ -L "$SYMLINK_TARGET_PATH" ]]; then
            if [[ "$(readlink "$SYMLINK_TARGET_PATH")" != "$SYMLINK_SOURCE_PATH" ]]; then
              echo "treefmt-nix: Removing existing symlink"
              unlink "$SYMLINK_TARGET_PATH"
            else
              exit 0
            fi
          fi

          nix-store --add-root "$SYMLINK_TARGET_PATH" --indirect --realise "$SYMLINK_SOURCE_PATH"
          echo "treefmt-nix: Created symlink successfully"
        '';
      };
  };

  flake.config.config = config;
}
