{inputs, ...}: {
  imports = [
    ./partitions
  ];

  systems = import inputs.systems;
}
