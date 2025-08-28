{ pkgs
, lib
, config
, ...
}:
with lib;
let
  cfg = config.my.components.terminal;
  cfgOs = config.my.os;
  cfgNixOnDroid = config.my.components.nixOnDroid;
  isNixOnDroid = cfgOs.type == "nix-on-droid";
  isNixOs = cfgOs.type == "nixos";
  isHomeManagerStandalone = cfgOs.isHomeManagerStandalone;
  writeUpdateScript =
    { command
    , needsRoot ? false
    ,
    }:
    pkgs.writeShellScriptBin "${command}-update" ''
      ${if needsRoot then "sudo " else ""}echo "Pulling & applying latest configuration"
      git -C ${config.my.meta.configurationDirectory} pull --recurse-submodules \
        && ${command}
    '';
in
{
  config =
    with lib;
    mkIf cfg.enable {
      home.sessionPath = [
        "$HOME/Dropbox/Scripts"
      ];
      home.packages =
        with pkgs;
        [
          (writeShellScriptBin "forward-ssh-agent" ''
            #!/usr/bin/env -S bash -e
            LOCAL_IP=192.168.69.1
            LOCAL_PORT=2222
            echo "================================================================================"
            echo "Run socat on your client machine:"
            echo "  windows: winsocat NPIPE-LISTEN:openssh-ssh-agent TCP:$LOCAL_IP:$LOCAL_PORT"
            echo "    (to install: dotnet tool install -g winsocat)"
            echo "  linux: socat UNIX-LISTEN:\$SSH_AUTH_SOCK,fork TCP:$LOCAL_IP:$LOCAL_PORT"
            echo "================================================================================"
            echo ""
            ${getExe pkgs.socat} -dd TCP-LISTEN:$LOCAL_PORT,fork,bind=$LOCAL_IP UNIX-CONNECT:$SSH_AUTH_SOCK
          '')
        ]
        ++ (optionals isNixOs (
          let
            flakeArgs = "--override-input common path:/etc/nixos/flakes/common";
            mkNixosRebuild =
              command:
              "sudo nixos-rebuild ${command} --flake /etc/nixos#${config.my.meta.configurationNames.nixos} ${flakeArgs} \"$@\"";
          in
          [
            (writeShellScriptBin "nrs" (mkNixosRebuild "switch"))
            (writeShellScriptBin "nrt" (mkNixosRebuild "test"))
            (writeShellScriptBin "nrb" (mkNixosRebuild "boot"))
            (writeShellScriptBin "nre" "nix eval /etc/nixos#nixosConfigurations.${config.my.meta.configurationNames.nixos}.config.system.build.toplevel ${flakeArgs} \"$@\"")
            (writeUpdateScript {
              command = "nrs";
              needsRoot = true;
            })
            (writeUpdateScript {
              command = "nrt";
              needsRoot = true;
            })
            (writeUpdateScript {
              command = "nrb";
              needsRoot = true;
            })
          ]
        ))
        ++ (optionals isHomeManagerStandalone [
          (writeShellScriptBin "hms" "home-manager switch --impure -b bak --flake ~/.config/home-manager#${config.my.meta.configurationNames.homeManager} \"$@\"")
          (writeShellScriptBin "hmn" "home-manager news --flake ~/.config/home-manager#${config.my.meta.configurationNames.homeManager} \"$@\"")
          (writeUpdateScript { command = "hms"; })
        ])
        ++ (optionals isNixOnDroid [
          (writeShellScriptBin "nods" (
            let
              wakelockToolAvailable = cfgNixOnDroid.tools.wake-lock.enable;
              lockCmd = if wakelockToolAvailable then "termux-wake-lock" else "";
              unlockCmd = if wakelockToolAvailable then "termux-wake-unlock" else "";
            in
            ''
              ${lockCmd}
              nix-on-droid switch --flake ~/.config/nix-on-droid#${config.my.meta.configurationNames.nixOnDroid} "$@"
              ${unlockCmd}
            ''
          ))
          (writeUpdateScript { command = "nods"; })
        ]);
    };
}
