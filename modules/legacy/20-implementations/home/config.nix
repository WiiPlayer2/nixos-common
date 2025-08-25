{ lib, config, ... }:
with lib;
let
  cfg = config.my.config;
in
{
  # nix.settings = cfg.nix.settings; # TODO: implement setting of nix settings
}
