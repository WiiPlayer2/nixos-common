{
  perSystem =
    { pkgs, self', lib, ... }:
    {
      apps.__ci__pkgs_update = {
        program =
          let
            packages = lib.attrsToList self'.packages;
            updatePackage =
              { name, value }:
              let
                pkg = value;
                isSkipped = if pkg.passthru ? skipUpdate then pkg.passthru.skipUpdate else false;
                baseUpdateCommand =
                  if pkg.passthru ? updateScript
                  then
                    if lib.isList pkg.passthru.updateScript
                    then lib.escapeShellArgs pkg.passthru.updateScript
                    else "${pkg.passthru.updateScript}"
                  else "nix-update";
                baseUpdateCommand' =
                  if (builtins.match ".*nix-update.*" baseUpdateCommand) != null
                  then "${baseUpdateCommand} -F"
                  else baseUpdateCommand;
                command = "${baseUpdateCommand'} $NIX_UPDATE_ARGS ${name}";
                updateCommand =
                  if isSkipped
                  then ''
                    echo "[ ${name} (skipped) ]"
                  ''
                  else ''
                    echo "[ ${name} ]"
                    echo ">>" ${command}

                    if ! ${command}; then
                      _failures="$_failures ${name}"
                    fi
                  '';
              in
              updateCommand;
            updatePackages =
              lib.concatStringsSep
                "\n"
                (
                  lib.map
                    updatePackage
                    packages
                );

            runScript = pkgs.writeShellApplication {
              name = "pkgs-update";
              runtimeInputs = with pkgs; [
                nix-update
              ];
              text = ''
                echo "===[ Updating packages ]==="

                NIX_UPDATE_ARGS=""
                if [ -n "''${CI:-}" ]; then
                  git config --global user.name "CI"
                  git config --global user.email "ci@home"
                  NIX_UPDATE_ARGS="--commit"
                fi

                _failures=""
                ${updatePackages}

                if [ -n "''${CI:-}" ]; then
                  echo "===[ Sync with repository ]==="
                  git pull origin "$(git rev-parse --abbrev-ref HEAD)" --rebase
                  git push
                fi

                if [[ -n "$_failures" ]]; then
                  echo "===[ FAILURE ]==="
                  echo "The following packages did not update successfully:$_failures"
                  exit 1
                fi

                echo "===[ DONE ]==="
              '';
            };
          in
          runScript;
      };
    };
}
