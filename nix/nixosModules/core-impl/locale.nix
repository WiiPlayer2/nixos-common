{
  lib,
  config,
  options,
  ...
}:
with lib;
{
  time.timeZone = "Europe/Berlin";
  console.keyMap = "de";

  programs = optionalAttrs (options.programs ? dank-material-shell) {
    dank-material-shell.greeter.compositor.customConfig =
      if config.programs.dank-material-shell.greeter.compositor.name == "sway" then
        ''
          input "*" {
            xkb_layout de
          }
        ''
      else
        warn "No locale config for DankMaterialShell compositor ${config.programs.dank-material-shell.greeter.compositor.name} configured yet." "";
  };
}
