{
  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    flake-parts-builder = {
      url = "github:tsandrini/flake-parts-builder";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    systems = {
      url = "github:nix-systems/default";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://pre-commit-hooks.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };

  outputs =
    {
      flake-parts,
      flake-parts-builder,
      ...
    }@inputs:
    let
      inherit (flake-parts-builder.lib) loadParts;
    in
    flake-parts.lib.mkFlake { inherit inputs; } { imports = loadParts ./flake; };
}
