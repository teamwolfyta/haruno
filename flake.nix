{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  nixConfig = {
    extra-substituters = [
      "https://haruno.cachix.org"
    ];
    extra-trusted-public-keys = [
      "haruno.cachix.org-1:ujqqGR45bFhbAaDWg9owXuG71PZnLvynF/MjvRxrK5k="
    ];
  };

  outputs = {flake-parts, ...} @ inputs: flake-parts.lib.mkFlake {inherit inputs;} {imports = [./flake];};
}
