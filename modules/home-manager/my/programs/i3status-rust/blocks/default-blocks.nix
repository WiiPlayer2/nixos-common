{ pkgs
, lib
, config
, ...
}:
{
  config.my.components.graphical.windowManager.i3.extraBlocks = {
    music = {
      bar = "bottom";
      block = {
        block = "music";
        # format = " $icon {$combo.str(max_w:25,rot_interval:0.5) {$volume_icon $volume|}$prev $play $next |}";
        format = " $icon {$combo.str(max_w:50,rot_interval:0.5) $prev $play $next |}";
        # format_alt = " $icon {$title.str(max_w:10) $prev $play $next |}";
        click = [
          {
            button = "up";
            action = "volume_up";
          }
          {
            button = "down";
            action = "volume_down";
          }
        ];
      };
      order = 100;
    };

    weather = {
      bar = "bottom";
      block = {
        block = "weather";
        autolocate = true;
        format = " $icon $weather $temp, $wind m/s $direction ";
        format_alt = " $icon_ffin Forecast (12 hour avg) {$temp_favg ({$temp_fmin}-{$temp_fmax})|Unavailable} ";
        service = {
          name = "metno";
        };
      };
      order = 50;
    };

    teaTimer = {
      bar = "bottom";
      order = 25;
      block = {
        block = "tea_timer";
        done_cmd =
          with lib;
          let
            # TODO: inject asset path through config or special arg
            notificationSound = config.my.assets.files.sounds.notifications."notification-18-270129.mp3";
            notifyScript = pkgs.writeShellScript "tea-timer-notify" ''
              MSG="$1"
              notify-send --urgency=critical Tea Timer "$MSG"
              ${pkgs.ffmpeg}/bin/ffplay -v 0 -nodisp -autoexit "${notificationSound}"
            '';
          in
          "${notifyScript} \"Tea is ready.\"";
      };
    };

    nixBuilds =
      let
        script = pkgs.writeShellApplication {
          name = "nix-builds-i3block";
          runtimeInputs = with pkgs; [
            procps
            uutils-coreutils-noprefix
            jq
          ];
          text = ''
            _procUsers="$(ps -g nixbld -o ruser --no-headers || true)"
            _text=""
            _shortText=""
            _state="Idle"

            if [ -n "$_procUsers" ]; then
              _jobCount="$(echo "$_procUsers" | sort -u | wc -l)"
              _procCount="$(echo "$_procUsers" | wc -l)"
              _text=" $_jobCount build(s) | $_procCount process(es)"
              _shortText=" $_jobCount"
              _state="Warning"
            fi

            jq \
              --arg icon "update" \
              --arg state "$_state" \
              --arg short_text "$_shortText" \
              --arg text "$_text" \
              -n \
              '{ icon: $icon, state: $state, short_text: $short_text, text: $text }'
          '';
        };
      in
      {
        bar = "bottom";
        order = 10;
        block = {
          block = "custom";
          json = true;
          command = lib.getExe script;
          # hide_when_empty = true;
          interval = 3;
          format = " $icon$text.pango-str() ";
        };
      };
  };
}
