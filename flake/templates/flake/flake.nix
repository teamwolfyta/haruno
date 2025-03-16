{
  outputs =
    { conflake, systems, ... }@inputs:
    conflake ./. {
      inherit inputs systems;

      nixDir.src = ./flake;
      presets.enable = false;
    };

  inputs = {
    conflake = {
      url = "github:ratson/conflake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    systems = {
      url = "github:nix-systems/x86_64-linux";
    };
  };
}
