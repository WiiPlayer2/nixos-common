{
  nixpkgs.overlays = [
    (final: prev: {
      # there might be a faster way than to override the actual package
      signal-desktop = prev.signal-desktop.overrideAttrs (
        finalAttrs: prevAttrs: {
          desktopItems = [
            ((builtins.elemAt prevAttrs.desktopItems 0).override {
              exec = "${finalAttrs.meta.mainProgram} --password-store=\"gnome-libsecret\" %U";
            })
          ];
        }
      );
    })
  ];
}
