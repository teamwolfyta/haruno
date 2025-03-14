let
  inherit (builtins) attrNames getFlake listToAttrs;
  flake = getFlake (toString ./.);
  names = attrNames flake;
  inherited = listToAttrs (
    map (name: {
      inherit name;
      value = flake.${name};
    }) names
  );
in
inherited // { inherit flake; }
