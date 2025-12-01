{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.components.terminal;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      home.packages = with pkgs; [
        sops
        gnupg
        age-plugin-yubikey
        k9s
        fluxcd
        kubectl
        pv-migrate
        python3
        ncdu
        btop

        vim
        nano
        code-server

        git
        openssh
        which
        htop
        tmux

        procps
        killall
        diffutils
        findutils
        util-linux
        tzdata
        hostname
        man
        gnugrep
        gnupg
        gnused
        gnutar
        bzip2
        gzip
        xz
        zip
        unzip
        box64
      ];
    };
}
