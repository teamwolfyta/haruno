{pkgs, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # Misc
    commitlint-rs
    editorconfig-checker
    jsonfmt
    lefthook
    mdformat
    treefmt
    taplo

    # Nix
    alejandra
    deadnix
    nil
    statix

    # Yaml
    actionlint
    yamlfmt
  ];

  shellHook = ''
    lefthook install
  '';
}
