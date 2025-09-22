{ lib, config, ... }:
with lib;
let
  cfg = config.services.picom;
  cfgOs = config.my.os;
in
{
  config = mkMerge [
    {
      services.picom = {
        enable = config.xsession.windowManager.i3.enable;
        # package = pkgs.picom-pijulius; # DO NOT ENABLE. Seems kinda broken atm due to inactive workspaces still being rendererd in the background
        backend = "glx"; # does not work in virtualized environment
        fade = true;
        shadow = true;
        activeOpacity = 0.95;
        inactiveOpacity = 0.8;
        opacityRules = [
          # "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
          # "0:!_NET_WM_STATE@[*]:a = '_NET_WM_STATE_FOCUSED'"
          # "0:_NET_WM_STATE@:a = ''"
          # "100:name *= 'Steam'" # Should be improved so it only applies to actual steam
          "100:_NET_WM_STATE@[*]:a = '_NET_WM_STATE_FULLSCREEN'"
          "100:class_g ?= 'overlayed'"
        ];
        shadowExclude = [
          # "class_general = 'i3bar'"
          "class_g ?= 'overlayed'"
          "class_g ?= 'Screenkey'"
          "class_g ?= 'gnome-calculator'"
        ];
        vSync = true;
        settings = {
          wintypes = {
            dock = {
              fade = false;
              shadow = false;
            };
          };
          blur = {
            method = "dual_kawase";
            size = 20; # gaussian, box
            deviation = 15; # gaussian
            strength = 0; # dual_kawase
          };
          blur-background-exclude = [
            "class_g ?= 'xfce4-screenshooter'" # https://www.reddit.com/r/linuxquestions/comments/15xoqa4/compositor_blur_and_xfce4screenshooter/
            "class_g ?= 'overlayed'"
            "class_g ?= 'Screenkey'"
            "class_g ?= 'gnome-calculator'"
          ];
        };
        # extraArgs = [
        #   # https://github.com/yshui/picom/issues/404#issuecomment-732338519
        #   # "--transparent-clipping"
        #   # "--experimental-backends"
        #   # "--no-use-damage"
        #   # "--use-ewmh-active-win"
        # ];
      };
    }
    (mkIf cfg.enable {
      # TODO: this should maybe be moved to extra with an option like "useNixGL"
      systemd.user.services.picom.Service.ExecStart =
        let
          inherit (lib)
            getExe
            getExe'
            mkForce
            optionals
            ;
          cfg = config.services.picom;
        in
        mkForce (
          concatStringsSep " " (
            (optionals (cfgOs.type != "nixos") [
              "${getExe' pkgs.nixgl.nixGLDefault "nixGL"}" # Needed for non NixOS systems, might also check backend before prepending this
            ])
            ++ [
              "${getExe cfg.package}"
              "--config ${config.xdg.configFile."picom/picom.conf".source}"
            ]
            ++ cfg.extraArgs
          )
        );
    })
  ];
}
