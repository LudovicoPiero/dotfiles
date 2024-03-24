{
  inputs,
  cell,
}:
inputs.hive.findLoad {
  inherit inputs cell;
  block = ./.;
}
