{
  inputs,
  hostPlatform,
}:
inputs.dms-plugin-calendar.packages.${hostPlatform.system}.dankcalendar.overrideAttrs {
  patches = [
    ./01-allow-insecure.patch
  ];
}
