{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.imprinting;
in
{
  # required for yubikey
  services.pcscd.enable = true;

  environment.systemPackages =
    let
      identity = ../../../secrets/identities/yubikey.pub;
      getScriptName = name: "imprint-${name}";
      imprintingScript =
        { name
        , file
        , path
        , script
        , mode
        , ...
        }:
        pkgs.writeShellApplication {
          name = getScriptName name;
          runtimeInputs = with pkgs; [
            rage
            age-plugin-yubikey
          ];
          text = ''
            if [ "$EUID" -ne 0 ]
              then echo "Please run as root"
              exit
            fi

            if [ -f '${path}' ]; then
              echo "${path} already exists"
              exit
            fi

            echo "${path} is now being imprinted..."
            rage -i '${identity}' -d '${file}' -o '${path}'
            chmod ${mode} '${path}'
            ${script}
            echo "${path} imprinted."
          '';
        };
      imprintingScriptCalls = concatStringsSep "\n" (
        map
          (
            { name, value }:
            let
              script = imprintingScript value;
              scriptName = getScriptName name;
            in
            ''
              ${script}/bin/${scriptName}
            ''
          )
          (attrsToList cfg.files)
      );
      completeImprintingScript = pkgs.writeShellApplication {
        name = "imprint-system-files";
        text = ''
          if [ "$EUID" -ne 0 ]
            then echo "Please run as root"
            exit
          fi

          echo "===[ Imprinting system files ]==="
          ${imprintingScriptCalls}
          echo "===[ DONE ]==="
        '';
      };
    in
    [
      completeImprintingScript
    ];
}
