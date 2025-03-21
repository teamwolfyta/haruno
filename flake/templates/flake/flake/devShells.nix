_: {
  perSystem =
    { self', pkgs, ... }:
    {
      devShells.default =
        let
          checks = self'.checks.default;
        in
        pkgs.mkShell {
          inherit (checks) shellHook;

          nativeBuildInputs =
            checks.enabledPackages
            ++ (with pkgs; [
              nil
            ]);
        };
    };
}
