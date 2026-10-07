{
  inputs,
  stdenv,
}:
inputs.dms-plugin-calendar.packages.${stdenv.hostPlatform.system}.dankcalendar.overrideAttrs {
  patches = [
    ./01-allow-insecure.patch
  ];
}
