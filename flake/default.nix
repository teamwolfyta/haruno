{inputs, ...}: {
  systems = import inputs.systems;

  perSystem = {pkgs, ...}: {
    devShells.default = import ./shell.nix {inherit pkgs;};
  };
}
