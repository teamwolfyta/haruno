{config, ...}: {
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        actionlint
        alejandra
        commitlint-rs
        deadnix
        editorconfig-checker
        jsonfmt
        mdformat
        nil
        pre-commit
        statix
        treefmt
        yamlfmt
      ];

      shellHook = ''
        pre-commit install
      '';
    };
  };

  flake.config.config = config;
}
