{
  buildFHSEnv,
}:
buildFHSEnv {
  name = "screenpipe-fhs";
  targetPkgs =
    pkgs: with pkgs; [
      nodejs_25
      libgbm
      kdePackages.wayland
      libxcb
      openblas
      openssl_3
      dbus
      pulseaudio
      ffmpeg
      tesseract
    ];
  runScript = "npx -y screenpipe@latest";
}

# writeShellApplication {
#   name = "screenpipe-fhs";
#   runtimeInputs = [
#     nodejs_25
#   ];
#   text = [

#   ];
# }
