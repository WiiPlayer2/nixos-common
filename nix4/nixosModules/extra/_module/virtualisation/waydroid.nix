{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.virtualisation.waydroid;

  waydroidX11Wrapper = pkgs.writeShellApplication {
    name = "waydroid";
    runtimeInputs = with pkgs; [
      cfg.x11Support.packages.weston
      cfg.x11Support.packages.waydroid

      util-linux
    ];
    text = ''
      # echo "[ARGS: $*]"
      _args="$*"

      function isWayland {
        [ "''${WAYLAND_DISPLAY:-}" ]
      }

      function isX11 {
        [ "''${DISPLAY:-}" ]
      }

      function isGraphical {
        isWayland || isX11
      }

      function startWeston {
        weston \
          --socket="$WAYLAND_DISPLAY" \
          --backend=x11-backend.so \
          --shell=kiosk-shell.so \
          --width=1280 \
          --height=720 \
          > /dev/null 2>&1 & disown
        echo "$!" > "$_westonPidFile"
        sleep 3 # wait for socket to be available
      }

      function needGraphical {
        ! [[ "$_args" =~ "--help" ]] && [[ "$_args" =~ first-launch|show-full-ui ]]
      }

      function ensureWeston {
        _westonPidFile="/run/user/$UID/waydroid-weston.pid"
        if [ -e "$_westonPidFile" ]; then
          _pid="$(cat $_westonPidFile)"
          if ! ps -p "$_pid" > /dev/null || grep zombie "/proc/$_pid/status" > /dev/null ; then
            startWeston
          fi
        else
          startWeston
        fi
      }

      if needGraphical && isX11; then
        export WAYLAND_DISPLAY="waydroid-1"
        ensureWeston
      fi

      exec waydroid "$@"
    '';
  };

  wrappedWaydroid = pkgs.symlinkJoin {
    name = "${cfg.x11Support.packages.waydroid.pname}-x11";
    version = cfg.x11Support.packages.waydroid.version;
    paths = [
      waydroidX11Wrapper
      cfg.x11Support.packages.waydroid
    ];
    passthru = cfg.x11Support.packages.waydroid.passthru;
    meta = cfg.x11Support.packages.waydroid.passthru;
  };
in
{
  options.virtualisation.waydroid = {
    x11Support = {
      enable = mkEnableOption "Whether support for X11 should be added.";
      packages = {
        waydroid = mkOption {
          type = types.package;
          default = pkgs.waydroid;
        };
        weston = mkOption {
          type = types.package;
          default = pkgs.weston;
        };
      };
    };
  };

  config = mkIf (cfg.enable && cfg.x11Support.enable) {
    virtualisation.waydroid.package = wrappedWaydroid;
  };
}
