{
  perSystem =
    {
      lib,
      config,
      pkgs,
      system,
      self',
      inputs',
      ...
    }:
    with lib;
    {
      devShells.default = makeOverridable pkgs.mkShell {
        name = "nix-configs";
        packages =
          with pkgs;
          with self'.legacyPackages;
          [
            config.agenix-rekey.package
            rage
            amnesia
            age-plugin-yubikey
            age-plugin-amnesia
            age-plugin-openpgp-card
            openpgp-card-tools
            inputs'.deploy-rs.packages.default
            inputs'.disko.packages.default

            nix-update
            nix-diff
            nix-eval-jobs
            nix-fast-build

            (writeShellApplication {
              name = "nixos-pkg-diff";
              runtimeInputs = [
                nix-diff
              ];
              text = ''
                HOST="$1"
                PKG="$2"

                printf "<resolving system: "
                _system=$(nix eval --override-input common path:"$FLAKE_ROOT"/flakes/common "$FLAKE_ROOT#nixosConfigurations.$HOST.pkgs.stdenv.hostPlatform.system" --raw 2>/dev/null)

                printf "%s>\n<evaluating nixos drv: " "$_system"
                _nixosDrv=$(nix eval --override-input common path:"$FLAKE_ROOT"/flakes/common "$FLAKE_ROOT#nixosConfigurations.$HOST.pkgs.$PKG.drvPath" --raw 2>/dev/null)

                printf "%s>\n<evaluating nixpkgs drv: " "$_nixosDrv"
                _nixpkgsDrv=$(nix eval --override-input common path:"$FLAKE_ROOT"/flakes/common --inputs-from "$FLAKE_ROOT" --system "$_system" "nixpkgs#$PKG.drvPath" --raw 2>/dev/null)

                echo "$_nixpkgsDrv>"
                nix-diff "$_nixpkgsDrv" "$_nixosDrv" --skip-already-compared
              '';
            })
            (writeShellApplication {
              name = "repl";
              runtimeInputs = [

              ];
              text = ''
                nix repl --extra-experimental-features 'repl-flake' "$FLAKE_ROOT" --override-input common path:"$FLAKE_ROOT"/flakes/common "$@"
              '';
            })
            (writeShellApplication {
              name = "deploy-to";
              runtimeInputs = [
                inputs'.deploy-rs.packages.default
                pkgs.nix-output-monitor
              ];
              text = ''
                TARGET="$1"
                shift

                _deployRsArgs=()
                _nixArgs=()
                _doubleHyphenSeen=false

                for arg in "$@"; do
                  if [ "$_doubleHyphenSeen" == false ] && [ "$arg" == "--" ]; then
                    _doubleHyphenSeen=true
                    continue
                  fi

                  if [ "$_doubleHyphenSeen" == false ]; then
                    _deployRsArgs+=("$arg")
                  else
                    _nixArgs+=("$arg")
                  fi
                done

                deploy --skip-checks .#"$TARGET" "''${_deployRsArgs[@]}" -- --override-input common path:"$FLAKE_ROOT"/flakes/common --log-format internal-json --verbose "''${_nixArgs[@]}" |& nom --json
              '';
            })
            (writeShellApplication {
              name = "build-nixos";
              runtimeInputs = [
                nix-fast-build
                nix-output-monitor
              ];
              text = ''
                TARGET="$1"
                shift
                _cpus=$(nproc)
                _freeMB=$(free --mega --line | awk '{ print $8 }')
                _workerMB=$((_freeMB / (_cpus * 4)))
                _workers=$((_freeMB / (4096 * 2)))
                # nix-fast-build --flake "$FLAKE_ROOT"#nixosConfigurations."$TARGET".config.system.build.toplevel --override-input common path:"$FLAKE_ROOT"/flakes/common "$@"
                # nix-fast-build --flake "$FLAKE_ROOT"#nixosConfigurations."$TARGET".config.system.build.toplevel --override-input common path:"$FLAKE_ROOT"/flakes/common --eval-workers "$_workers" "$@"
                nom build "$FLAKE_ROOT"#nixosConfigurations."$TARGET".config.system.build.toplevel --override-input common path:"$FLAKE_ROOT"/flakes/common "$@"
              '';
            })
            (writeShellApplication {
              name = "eval-nixos";
              runtimeInputs = [
                # nix
              ];
              text = ''
                TARGET="$1"
                shift
                nix eval "$FLAKE_ROOT"#nixosConfigurations."$TARGET".config.system.build.toplevel --override-input common path:"$FLAKE_ROOT"/flakes/common "$@"
              '';
            })
            (writeShellApplication {
              name = "build-nix-on-droid";
              runtimeInputs = [
                nix-output-monitor
              ];
              text = ''
                TARGET="$1"
                shift
                nom build "$FLAKE_ROOT"#nixOnDroidConfigurations."$TARGET".activationPackage --override-input common path:"$FLAKE_ROOT"/flakes/common --impure "$@"
              '';
            })
            (writeShellApplication {
              name = "eval-nix-on-droid";
              runtimeInputs = [
                # nix
              ];
              text = ''
                TARGET="$1"
                shift
                nix eval "$FLAKE_ROOT"#nixOnDroidConfigurations."$TARGET".activationPackage --override-input common path:"$FLAKE_ROOT"/flakes/common --impure "$@"
              '';
            })
            (
              let
                createDefaultNix = writeShellApplication {
                  name = "create-default-nix";
                  text = ''
                    cat > default.nix << EOF
                    # DO NOT EDIT! This file was auto-generated by 'update-import-all-defaults' because the file '.nix-import-all' is inside this directory
                    {
                      imports = [
                    EOF

                    for file in ./*.nix ./.*.nix ./*/ ./.*/; do
                      if [ ! -e "$file" ] || [ "$file" == "./default.nix" ] || { [ -d "$file" ] && [ ! -f "$file/.nix-import-all" ] && [ ! -f "$file/default.nix" ]; }; then
                        continue
                      fi

                      echo "    ''${file%/}" >> default.nix
                    done

                    cat >> default.nix << EOF
                      ];
                    }
                    EOF

                    realpath default.nix
                  '';
                };
              in
              writeShellApplication {
                name = "update-import-all-defaults";
                runtimeInputs = [
                  createDefaultNix
                ];
                text = ''
                  find "$FLAKE_ROOT" -name '.nix-import-all' -execdir create-default-nix \;
                '';
              }
            )
          ];
        shellHook = ''
          ${config.pre-commit.installationScript}
          export FLAKE_ROOT="$(pwd)"
        '';
      };
    };
}
