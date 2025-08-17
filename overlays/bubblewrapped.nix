{ self, ... }:
{
  flake.overlays.bubblewrapped =
    final: prev: {
      # discord = final.bubblewrapped.discord;

      bubblewrapped = {
        discord = self.legacyPackages.${prev.system}.bwrapPkg {
          package = prev.discord;
          binds = [
            {
              type = "rw";
              path = "$HOME/.config/discord";
              escape = false;
            }

            # for x11
            {
              path = "$HOME/.Xauthority";
              escape = false;
            }
            # {
            #   path = "/tmp/.X11-unix/X0";
            #   readonly = false;
            # }

            # to resolve DNS requests
            {
              path = "/etc/resolv.conf";
            }

            # for local timezone
            {
              path = "/etc/localtime";
            }

            # for fonts (otherwise crashes)
            {
              path = "/etc/fonts";
            }

            # for sound
            {
              path = "/run/user/$UID/pulse";
              escape = false;
            }

            # TODO: use socat to passthrough socket, for now make folder writable
            {
              type = "rw";
              path = "/run/user/$UID";
              escape = false;
            }

            # NOTE: this only works on NixOS for now
            {
              path = "${final.flatpak-xdg-utils}/bin/xdg-open";
              target = "/run/current-system/sw/bin/xdg-open";
            }
          ];
          extraArgs = [
            "--proc"
            "/proc"
            "--dev"
            "/dev"
          ];
          extraArgsRaw = [
          ];
        };
      };
    };
}
