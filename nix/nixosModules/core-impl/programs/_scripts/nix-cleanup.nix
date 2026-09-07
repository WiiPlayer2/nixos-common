{
  writeShellApplication,
}:
writeShellApplication {
  name = "nix-cleanup";
  runtimeInputs = [

  ];
  text = ''
    # Always run as root
    [ "$(id -u)" != 0 ] && exec sudo "$0"

    echo "=== [ Remove auto roots ] ==="
    for root in /nix/var/nix/gcroots/auto/*; do
      if [[ -e "$root" ]]; then
        rm -v "$(readlink "$root")"
      fi
    done

    echo "=== [ Collect system garbage ] ==="
    nix-collect-garbage --delete-old
  '';
}
