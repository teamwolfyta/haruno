{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  nixConfig = {
    extra-substituters = [
      "https://haruno.cachix.org"
      "https://numtide.cachix.org"
      "https://pre-commit-hooks.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "haruno.cachix.org-1:ujqqGR45bFhbAaDWg9owXuG71PZnLvynF/MjvRxrK5k="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };

  outputs = {flake-parts, ...} @ inputs: flake-parts.lib.mkFlake {inherit inputs;} {imports = [./flake];};
}
