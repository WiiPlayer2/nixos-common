{
  lib,
  config,
  pkgs,
  ...
}@inputs:
let
  i3lib = import ../../lib.nix { inherit lib config; };
  machineCfg = config.my.machine;
  cfgOs = config.my.os;
  isNotNixOnDroid = cfgOs.type != "nix-on-droid";
  i3scripts = import ../../scripts inputs;
  cfgBlocks = config.my.components.graphical.windowManager.i3.blocks;
in
with lib;
rec {
  diskSpace = {
    block = "disk_space";
    path = cfgBlocks.diskSpace.path;
  };

  speedtest = mkIf cfgBlocks.speedtest.enable {
    block = "speedtest";
    format = " ^icon_ping$ping.eng(w:1,p:m) ^icon_net_down$speed_down.eng(w:1,u:B) ^icon_net_up$speed_up.eng(w:1,u:B) ";
  };

  time = [
    {
      block = "time";
      format = mkIf (!cfgBlocks.time.showDate) " $icon $timestamp.datetime(f:%R) ";
    }
    # {
    #   block = "time";
    #   format = "$icon $timestamp.datetime(f:%R) (London) ";
    #   timezone = "Europe/London";
    #   theme_overrides = {
    #     idle_bg = "#001818";
    #   };
    # }
  ];

  moveButtons =
    let
      m = v: mkIf cfgBlocks.moveButtons.enable v;
    in
    [
      (m {
        block = "custom";
        format = "$text.pango-str()";
        command = "echo \" [&lt;] \"";
        interval = "once";
        click = [
          {
            button = "left";
            cmd = i3scripts.move-to-workspace-left;
          }
        ];
      })
      (m {
        block = "custom";
        format = "$text.pango-str()";
        command = "echo \" [&gt;] \"";
        interval = "once";
        click = [
          {
            button = "left";
            cmd = i3scripts.move-to-workspace-right;
          }
        ];
      })
    ];

  notifications = mkIf cfgBlocks.notifications.enable {
    block = "notify";
    format = " $icon {($notification_count.eng(w:1)) |}";
    click = [
      {
        button = "left";
        action = "show";
      }
      {
        button = "right";
        action = "toggle_paused";
      }
    ];
  };

  memory = mkIf isNotNixOnDroid {
    block = "memory";
    format = " $icon $mem_used_percents.eng(w:2) ";
    format_alt = " $icon $mem_used.eng(prefix:Mi)/$mem_total.eng(prefix:Mi)($mem_used_percents.eng(w:2)) ";
  };

  extraBlocks = import ./extra.nix inputs;

  all = [
    {
      block = "focused_window";
      format = {
        short = " $title.str(max_w:15) |";
        full = " $title.str(max_w:45) |";
      };
    }
    (mkIf isNotNixOnDroid {
      block = "net";
      format = " $icon ^icon_net_down$speed_down.eng(w:1,p:K) ^icon_net_up$speed_up.eng(w:1,p:K) ";
      format_alt = " $icon {$signal_strength $ssid $frequency.eng(w:1)|Wired connection} via $device ($ip) ^icon_net_down $graph_down $speed_down.eng(w:1,p:K) ^icon_net_up $graph_up $speed_up.eng(w:1,p:K) ";
    })
    speedtest
  ]
  ++ [
    diskSpace
    (mkIf isNotNixOnDroid {
      block = "cpu";
    })
    memory
    (mkIf machineCfg.devices.battery.enable {
      block = "battery";
      full_threshold = 84;
      format = " $icon $percentage \\($time_remaining \\| $power\\) ";
    })
    (mkIf machineCfg.devices.displayBacklight.enable {
      block = "backlight";
      minimum = 0;
    })
    (mkIf isNotNixOnDroid {
      block = "sound";
      click = [
        {
          button = "left";
          cmd = "pavucontrol";
        }
        {
          button = "middle";
          cmd =
            let
              audioDeviceSwitchScriptSrc = pkgs.fetchurl {
                url = "https://gist.githubusercontent.com/kbravh/1117a974f89cc53664e55823a55ac320/raw/9d04a10ae925074536047ae8100c6b0dbfc303d6/audio-device-switch.sh";
                hash = "sha256-OP7WFJlABxF06xsOyt99U3tJP1OYPjkYZCnyMp+K8rM=";
              };
              audioDeviceSwitchScript = pkgs.writeShellApplication {
                name = "audio-device-switch";
                runtimeInputs = with pkgs; [
                  bash
                  libnotify
                  pulseaudio
                ];
                text = ''
                  bash ${audioDeviceSwitchScriptSrc}
                '';
              };
            in
            lib.getExe audioDeviceSwitchScript;
        }
      ];
    })
  ]
  ++ extraBlocks
  ++ time
  ++ [ notifications ]
  ++ moveButtons;
}
