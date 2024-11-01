{
  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      nixpkgs,
      devenv,
      ...
    }@inputs:
    let
      forEachSystem =
        function:
        nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system: function nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forEachSystem (pkgs: {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            (_: {
              languages = {
                nix.enable = true;
                shell.enable = true;
              };

              pre-commit.hooks = {
                commitlint-rs = {
                  enable = true;
                  entry = "commitlint --edit";
                  language = "rust";
                  package = pkgs.commitlint-rs;
                  pass_filenames = false;
                  stages = [ "commit-msg" ];
                };
                deadnix.enable = true;
                shellcheck.enable = true;
                shfmt.enable = true;
                statix.enable = true;
                nixfmt-rfc-style.enable = true;
              };
            })
          ];
        };
      });
    };
}
