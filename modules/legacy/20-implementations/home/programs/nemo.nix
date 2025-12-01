{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.nemo;
in
{
  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        nemo-with-extensions
      ];
    })
    # TODO: move to stylix module, disabling xconf settings kinda fixed nemo themeing
    # https://askubuntu.com/a/1310485
    # https://github.com/linuxmint/mint-themes/blob/712039deb45e465c28dd4c27f65745e7dfb09c9a/src/Mint-Y/gtk-3.0/sass/_applications.scss#L241
    # (mkIf config.stylix.targets.gtk.enable {
    #   stylix.targets.gtk.extraCss =
    #     with config.lib.stylix.colors.withHashtag;
    #     let
    #       # TODO reference this: https://github.com/tinted-theming/home/blob/main/styling.md
    #       background = base00;
    #       darkerBackground = base01;
    #       darkBackground = base02;
    #       text = base05;
    #       accent = base0B;

    #       base = background;
    #       darkerBase = darkerBackground;
    #       sidebarFg = text;
    #       sidebarBg = darkBackground;
    #       sidebarMix = base04;
    #       selectedBg = darkerBackground;
    #       selectedDarkerBg = darkBackground;
    #       selectedFg = accent;
    #     in
    #     ''
    #       .nemo-window .nemo-inactive-pane .view {
    #         /* background-color: darken($base_color, 5%); */
    #         background-color: ${darkerBase};
    #       }

    #       .nemo-window .places-treeview {
    #         -NemoPlacesTreeView-disk-full-bg-color: ${sidebarFg};
    #         /* -NemoPlacesTreeView-disk-full-fg-color: darken($selected_bg_color, 10%); */
    #         -NemoPlacesTreeView-disk-full-fg-color: ${selectedDarkerBg};
    #       }
    #         .nemo-window .places-treeview .view.cell:hover {
    #           background-color: rgba(${sidebarFg}, 0.15);
    #         }

    #       .nemo-window .sidebar {
    #         color: ${sidebarFg};
    #         background-color: ${sidebarBg};
    #       }
    #         .nemo-window .sidebar .view, .nemo-window .sidebar row {
    #           background-color: ${sidebarBg};
    #           color: ${sidebarFg};
    #         }
    #           .nemo-window .sidebar .view.cell:selected, .nemo-window .sidebar row.cell:selected {
    #             background-color: ${selectedBg};
    #             color: ${selectedFg};
    #           }
    #           .nemo-window .sidebar .view.expander, .nemo-window .sidebar row.expander {
    #             /* color: mix($dark_sidebar_fg, $dark_sidebar_bg, 50%); */
    #             color: ${sidebarMix};
    #           }
    #             .nemo-window .sidebar .view.expander:hover, .nemo-window .sidebar row.expander:hover {
    #               color: ${sidebarFg};
    #             }
    #     '';
    # })
  ];
}
