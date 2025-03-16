{ outputs', pkgs, ... }:
let
  defaultChecks = outputs'.checks.default;
in
pkgs.mkShell {
  inherit (defaultChecks) shellHook;

  nativeBuildInputs =
    defaultChecks.enabledPackages
    ++ (with pkgs; [
      nil
    ]);
}
