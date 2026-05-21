{ lib, config, ... }:
with lib;
{
  time.timeZone = "Europe/Berlin";
  console.keyMap = "de";

  programs.dank-material-shell.greeter.compositor.customConfig =
    if config.programs.dank-material-shell.greeter.compositor.name == "sway" then
      ''
        input "*" {
          xkb_layout de
        }
      ''
    else
      warn "No locale config for DankMaterialShell compositor ${config.programs.dank-material-shell.greeter.compositor.name} configured yet." "";
}
