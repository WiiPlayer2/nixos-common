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

  age.generators.ssh-key = { pkgs, file, target, name, ... }: ''
    publicKeyFile=${lib.escapeShellArg (lib.removeSuffix ".age" file + ".pub")}
    privateKey=$(exec 3>&1; ${pkgs.openssh}/bin/ssh-keygen -q -t ed25519 -N "" -C ${lib.escapeShellArg "${target}:${name}"} -f /proc/self/fd/3 <<<y >/dev/null 2>&1; true)
    echo "$privateKey" | ssh-keygen -f /proc/self/fd/0 -y > "$publicKeyFile"
  '';
}
