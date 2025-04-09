{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.partitions];

  partitionedAttrs = {
    checks = "development";
    devShells = "development";
  };

  partitions."development" = {
    extraInputsFlake = ./development;
    module = {
      imports = [./development/flake-module.nix];
    };
  };
}
