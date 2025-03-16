let
  inherit (builtins) getFlake;
  flake = getFlake (toString ./.);
in
flake // { inherit flake; }
