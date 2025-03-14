{ outputs', pkgs, ... }:
let
  defaultChecks = outputs'.checks.default;
in
pkgs.mkShell {
  inherit (defaultChecks) shellHook;

  buildInputs =
    defaultChecks.enabledPackages
    ++ (with pkgs; [
      nil
    ]);
}
