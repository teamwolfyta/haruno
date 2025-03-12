{
  description = ''
    $$\     $$\          $$\       $$\
    \$$\   $$  |         $$ |      \__|
     \$$\ $$  /$$\   $$\ $$ |  $$\ $$\ $$$$$$$\   $$$$$$\
      \$$$$  / $$ |  $$ |$$ | $$  |$$ |$$  __$$\ $$  __$$\
       \$$  /  $$ |  $$ |$$$$$$  / $$ |$$ |  $$ |$$ /  $$ |
        $$ |   $$ |  $$ |$$  _$$<  $$ |$$ |  $$ |$$ |  $$ |
        $$ |   \$$$$$$  |$$ | \$$\ $$ |$$ |  $$ |\$$$$$$  |
        \__|    \______/ \__|  \__|\__|\__|  \__| \______/

    ❄️ Yukino (雪乃), The Nix(OS) Flake that powers my system(s).
  '';

  inputs = {
    devenv = {
      url = "github:cachix/devenv";
    };

    conflake = {
      url = "github:ratson/conflake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    systems = {
      url = "github:nix-systems/x86_64-linux";
    };
  };

  outputs =
    { conflake, systems, ... }@inputs:
    conflake ./. {
      inherit inputs systems;
      nixDir.src = ./flake;

      presets.enable = false;
    };
}
