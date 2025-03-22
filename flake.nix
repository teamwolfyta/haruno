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
