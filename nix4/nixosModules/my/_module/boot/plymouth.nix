{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.boot.plymouth.enable {
    boot = {
      kernelParams = [
        "quiet"
        "splash"
        "plymouth.use-simpledrm" # see https://gitlab.freedesktop.org/plymouth/plymouth/-/issues/264
      ];

      plymouth = {
        font = "${pkgs.nerd-fonts.fira-mono}/share/fonts/opentype/NerdFonts/FiraMono/FiraMonoNerdFont-Regular.otf";
        theme = "blahaj";
        themePackages = with pkgs; [
          plymouth-blahaj-theme
          catppuccin-plymouth
          nixos-bgrt-plymouth
          plymouth-matrix-theme
        ];
      };
    };
  };
}
