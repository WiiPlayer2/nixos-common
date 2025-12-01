{
  lib,
  config,
  inputs,
}:
config.nixDir3.extraInputs
// {
  inherit lib inputs config;
}
