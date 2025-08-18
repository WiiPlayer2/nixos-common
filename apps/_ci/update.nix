{
  perSystem =
    { pkgs, self', lib, ... }:
    {
      apps.__ci__update = {
        program =
          let
            run-script = pkgs.writeShellApplication {
              name = "__ci__update";
              runtimeInputs = with pkgs; [
                git
                coreutils
              ];
              text = ''
                NIX_FLAKE_UPDATE_ARGS=""
                if [ -n "''${CI:-}" ]; then
                  git config --global user.name "CI"
                  git config --global user.email "ci@home"
                  NIX_FLAKE_UPDATE_ARGS="--commit-lock-file"
                fi

                PRE_UPDATE_HASH=$(sha256sum flake.lock)
                nix flake update $NIX_FLAKE_UPDATE_ARGS
                POST_UPDATE_HASH=$(sha256sum flake.lock)

                if [ "$PRE_UPDATE_HASH" == "$POST_UPDATE_HASH" ]; then
                  echo "Flake inputs already up-to-date"
                  exit 0
                fi

                if [ -n "''${CI:-}" ]; then
                  git pull origin "$(git rev-parse --abbrev-ref HEAD)" --rebase
                  git push
                fi
              '';
            };
          in
          run-script;
      };
    };
}
