{ lib, options, ... }:
let
  placeholder = lib.mkOption {
    type = lib.types.raw;
    internal = true;
  };
in
{
  options = {
    environment = {
      pathsToLink = placeholder;
      systemPackages = options.environment.packages;
    };
    meta = placeholder;
    systemd = placeholder;
  };
}
