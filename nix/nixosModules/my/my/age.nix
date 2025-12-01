{ lib, config, ... }:
with lib;
let
  hasSecrets = config.age.secrets != { };
in
{
  age.rekey = {
    # placeholder ssh key if no secrets are set
    hostPubkey = mkIf (!hasSecrets) (mkDefault "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhujcXdQyd72976pL0nrspx1xn6JprfgrFuULMzI64p");
  };
}
