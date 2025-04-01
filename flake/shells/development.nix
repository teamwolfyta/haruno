{
  mkShellNoCC,
  nil,
  pre-commit,
  ...
}:
mkShellNoCC {
  inputsFrom = [pre-commit.devShell];

  nativeBuildInputs = [
    nil
  ];
}
