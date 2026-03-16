{ lib, ... }:
with lib;
{
  services.comin.enable = mkForce false;
}
