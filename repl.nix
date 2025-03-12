let
  flake = builtins.getFlake (toString ./.);
  names = builtins.attrNames flake;
  inherited = builtins.listToAttrs (
    map (name: {
      inherit name;
      value = flake.${name};
    }) names
  );
in
inherited // { inherit flake; }
