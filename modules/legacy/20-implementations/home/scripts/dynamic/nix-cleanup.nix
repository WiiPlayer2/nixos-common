{
  config,
  writeShellApplication,
}:
let
  mainUser = config.my.config.mainUser.name;
  isRootMainUser = mainUser == "root";
  collectCmd = "nix-collect-garbage --delete-older-than 3d";
in
writeShellApplication {
  name = "nix-cleanup";
  text = ''
    # Always run as root
    [ "$(id -u)" != 0 ] && exec sudo "$0"

    echo "=== [ Collect system garbage ] ==="
    ${collectCmd}
    ${
      if !isRootMainUser then
        ''
          printf "\n=== [ Collect user garbage ] ===\n"
          sudo -u ${mainUser} ${collectCmd}
        ''
      else
        ""
    }
  '';
}
