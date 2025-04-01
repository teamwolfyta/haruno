_: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells = rec {
      default = development;
      development = pkgs.callPackage ./development.nix {
        inherit (config) pre-commit;
      };
    };
  };
}
