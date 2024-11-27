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

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      src = ./.;
      namespace = "yukino";
    in
    inputs.snowfall-lib.mkFlake {
      inherit inputs src;

      snowfall = {
        inherit namespace;
      };

      channels-config = {
        allowUnfree = true;
      };

      outputs-builder = channels: {
        devShells.default = import ./shell.nix { inherit inputs channels; };
        formatter = channels.nixpkgs.nixfmt-rfc-style;
      };
    };
}
