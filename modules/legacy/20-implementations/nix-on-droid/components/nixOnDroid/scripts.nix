{ pkgs, ... }:
{
  environment.packages = with pkgs; [
    # https://gist.github.com/agnostic-apollo/dc7e47991c512755ff26bd2d31e72ca8#commands-to-disable-phantom-process-killing-and-tldr
    (writeShellScriptBin "fix-process-killing" ''
      alias adb="${pkgs.android-tools}/bin/adb"

      PORT=$1

      echo "Ensure Wireless debugging is enabled and your device is already paired."
      adb connect localhost:$PORT
      adb shell "settings put global settings_enable_monitor_phantom_procs false"
      adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
      adb disconnect localhost:$PORT
      echo "Done"
    '')
  ];
}
