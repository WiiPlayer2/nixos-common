{
  lib,
  config,
  super,
}:
lib.mkIf config.age.imprinting.enable [
  super.imprintingPkg
]
