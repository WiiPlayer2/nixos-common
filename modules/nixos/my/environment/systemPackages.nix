{ lib, pkgs, hostConfig, ... }:
with lib;
let
  flakeArgs = "--override-input common path:/etc/nixos/flakes/common";
  mkNixosRebuild =
    { name, useSudo, command }:
    let
      cmd = "${if useSudo then "sudo " else ""}nixos-rebuild ${command} --flake /etc/nixos#${hostConfig.name} ${flakeArgs} --log-format internal-json --verbose \"$@\" |& ${getExe pkgs.nix-output-monitor} --json";
    in
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = with pkgs; [
        nixos-rebuild
      ];
      text = ''
        exec ${cmd}
      '';
    };
  nixosEval = pkgs.writeShellScriptBin "nre" "nix eval /etc/nixos#nixosConfigurations.${hostConfig.name}.config.system.build.toplevel ${flakeArgs} \"$@\"";
in
{
  environment.systemPackages = with pkgs; [
    btop
    tmux
    lsof
    nix-output-monitor
    iotop-c
    entr
    tree
    dig.dnsutils

    (mkNixosRebuild { name = "nrs"; useSudo = true; command = "switch"; })
    (mkNixosRebuild { name = "nrb"; useSudo = true; command = "boot"; })
    (mkNixosRebuild { name = "nrt"; useSudo = true; command = "test"; })
    nixosEval
  ];
}
