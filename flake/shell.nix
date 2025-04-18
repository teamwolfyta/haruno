{pkgs, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    actionlint
    alejandra
    commitlint-rs
    deadnix
    editorconfig-checker
    jsonfmt
    lefthook
    mdformat
    nil
    statix
    treefmt
    yamlfmt
  ];

  shellHook = ''
    lefthook install
  '';
}
