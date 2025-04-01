{inputs, ...}: {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = _: {
    treefmt = {
      programs = {
        actionlint.enable = true;
        alejandra.enable = true;
        deadnix.enable = true;
        jsonfmt.enable = true;
        mdformat.enable = true;
        statix.enable = true;
        yamlfmt.enable = true;
      };
    };
  };
}
