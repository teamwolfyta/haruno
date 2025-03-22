{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [ config.pre-commit.devShell ];

        nativeBuildInputs = with pkgs; [
          nil
        ];
      };
    };
}
