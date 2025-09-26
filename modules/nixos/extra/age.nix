{ lib, ... }:
{
  age.generators.wireguard-priv = { pkgs, file, ... }: ''
    priv=$(${pkgs.wireguard-tools}/bin/wg genkey)
    ${pkgs.wireguard-tools}/bin/wg pubkey <<< "$priv" > ${lib.escapeShellArg (lib.removeSuffix ".age" file + ".pub")}
    echo "$priv"
  '';

  age.generators.age-identity = { pkgs, file, ... }: ''
    publicKeyFile=${lib.escapeShellArg (lib.removeSuffix ".age" file + ".pub")}
    ${pkgs.rage}/bin/rage-keygen 2> "$publicKeyFile"
    ${lib.getExe pkgs.gnused} 's/Public key: //' -i "$publicKeyFile"
  '';
}
