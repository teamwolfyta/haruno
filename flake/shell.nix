{pkgs, ...}:
pkgs.mkShell {
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
}
