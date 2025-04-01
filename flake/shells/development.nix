{
  gitMinimal,
  lib,
  mkShellNoCC,
  nil,
  pre-commit,
  treefmt,
  ...
}: let
  inherit (lib) getExe;
in
  mkShellNoCC {
    inputsFrom = [pre-commit.devShell treefmt.build.devShell];

    nativeBuildInputs = [
      nil
    ];

    shellHook = ''
      FLAKE_ROOT=$(${getExe gitMinimal} rev-parse --show-toplevel)
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
  }
