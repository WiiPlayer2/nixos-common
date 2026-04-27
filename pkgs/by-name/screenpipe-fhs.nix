{
  buildFHSEnv,
  writeShellApplication,

  bun,
}:
let
  pi = writeShellApplication {
    name = "pi";
    runtimeInputs = [
      bun
    ];
    text = "bun x --silent @mariozechner/pi-coding-agent \"$@\"";
  };
in
buildFHSEnv {
  name = "screenpipe";
  targetPkgs =
    pkgs: with pkgs; [
      libgbm
      kdePackages.wayland
      libxcb
      openblas
      openssl_3
      dbus
      pulseaudio
      ffmpeg
      tesseract
      pi
      bun
    ];
  runScript = "bun x --silent screenpipe@latest";
}
