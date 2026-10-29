{
  fetchurl,
  appimageTools,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "paperweight-appimage";
  version = "1.0.0";
  src = fetchurl {
    url = "https://github.com/wslyvh/paperweight/releases/download/v1.0.0/Paperweight-${finalAttrs.version}.AppImage";
    hash = "sha256-uV4dbEG8DY6u80ZiGOlNmB0HR3ik52bnvQqGO/MgeIU=";
  };
})
