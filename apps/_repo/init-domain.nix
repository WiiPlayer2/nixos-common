{
  perSystem =
    { pkgs, self', lib, ... }:
    {
      apps.__repo__init-domain = {
        program =
          let
            run-script = pkgs.writeShellApplication {
              name = "init-domain";
              runtimeInputs = with pkgs; [
                git
                direnv
              ];
              text = ''
                git init
                git submodule add https://github.com/WiiPlayer2/nixos-common.git flakes/common
                git add .
                git commit -m "Add domain nixos files"
                direnv allow

                echo ""
                echo "[ Domain repo initialized. ]"
              '';
            };
          in
          run-script;
      };
    };
}
