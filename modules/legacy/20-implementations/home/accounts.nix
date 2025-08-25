{ lib, config, ... }:
with lib;
let
  cfg = config.my.accounts;
in
{
  config.accounts.email.accounts = mapAttrs
    (_: x: {
      address = x.address;
      primary = x.isPrimary;
      realName = x.realName;
    })
    cfg.email;
}
