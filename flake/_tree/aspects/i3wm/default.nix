{ lib, ... }:
with lib;
{
  flake.aspects.i3wm = {
    nixos =
      { pkgs, ... }:
      {
        services.logind.settings.Login = {
          IdleAction = "lock";
          IdleActionSec = "5s";
        };

        security = {
          cmd-polkit = {
            enable = true;
            mode = "serial";
            command = getExe (pkgs.callPackage ./_rofi-cmd-polkit.nix { });
          };

          pam.services.cinnamon-screensaver = {
            fprintAuth = true;
            u2fAuth = true;
          };
        };
      };

    homeManager =
      { pkgs, ... }:
      let
        xsetConfig = pkgs.writeShellApplication {
          name = "xset-config";
          runtimeInputs = with pkgs; [
            xorg.xset
          ];
          text = ''
            xset -dpms
            xset s off
          '';
        };

        setIdle =
          value:
          pkgs.writeShellApplication {
            name = "set-idle";
            runtimeInputs = with pkgs; [
              dbus
            ];
            text = ''
              dbus-send \
                --system \
                --print-reply \
                --type=method_call \
                --dest=org.freedesktop.login1 \
                "/org/freedesktop/login1/session/_3$XDG_SESSION_ID" \
                org.freedesktop.login1.Session.SetIdleHint \
                'boolean:${value}'
            '';
          };
      in
      {
        imports = [
          ./_home.nix
        ];

        xsession = {
          initExtra = ''
            dbus-update-activation-environment --systemd DISPLAY
          '';
          windowManager.i3 = {
            config = {
              keybindings =
                # let
                #   modifier = config.xsession.windowManager.i3.config.modifier;
                # in
                mkOptionDefault {
                  # TODO: add notifications
                  "XF86AudioMute" =
                    "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
                  "XF86AudioLowerVolume" =
                    "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
                  "XF86AudioRaiseVolume" =
                    "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
                  "Control+Mod1+L" = "exec ${pkgs.cinnamon-screensaver}/bin/cinnamon-screensaver-command --lock";
                  "Print" = "exec --no-startup-id ${getExe pkgs.shutter} --full";
                  "Control+Print" = "exec --no-startup-id ${getExe pkgs.shutter} --select";
                  "Mod1+Print" = "exec --no-startup-id ${getExe pkgs.shutter} --active";
                };

              startup = [
                { command = "${pkgs.cinnamon-screensaver}/bin/cinnamon-screensaver --hold"; }
                { command = "${getExe xsetConfig}"; }
                {
                  command = "${getExe pkgs.xidlehook} --timer 300 ${escapeShellArg (getExe (setIdle "true"))} ${escapeShellArg (getExe (setIdle "false"))}";
                }
              ];
            };

            extraConfig = ''
              for_window [class=".shutter-wrapped"] floating enable, resize set 1280 720, move position center
              for_window [class="Variety" title="Variety Images"] floating enable, sticky enable

              # Maybe split up different sub windows
              for_window [class="Pidgin"] floating enable, sticky enable
            '';
          };
        };

        home.packages = with pkgs; [
          cinnamon-screensaver
          xidlehook
          shutter
        ];

        services = {
          inhibridge.enable = true;
          picom = {
            shadowExclude = [
              "class_g ?= 'org.nickvision.cavalier'"
            ];
            settings.blur-background-exclude = [
              "class_g ?= 'org.nickvision.cavalier'"
            ];
          };
        };

        systemd.user.services.picom.Service.ExecCondition =
          "${pkgs.runtimeShell} -c \"! ${pkgs.systemd}/bin/systemd-detect-virt --vm\"";
      };
  };
}
