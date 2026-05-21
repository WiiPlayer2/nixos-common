{ inputs, ... }:
{ pkgs, ... }:
{
  imports = [
    inputs.dms.nixosModules.greeter
  ];

  programs = {
    sway = {
      enable = true;
      package = pkgs.swayfx;
    };
    # niri.enable = true;
    uwsm = {
      enable = true;
      waylandCompositors.sway = {
        prettyName = "Sway";
        comment = "Sway compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
    };

    dsearch.enable = true;
    dank-material-shell.greeter = {
      enable = true;
      compositor.name = "sway";
    };
  };

  services = {
    accounts-daemon.enable = true;
    power-profiles-daemon.enable = true;
    printing.enable = true;
    fprintd.enable = true;
  };

  security.pam.services = {
    dms-greeter = {
      fprintAuth = false;
      u2f.enable = false;
    };
    greetd = {
      fprintAuth = false;
      u2f.enable = false;
    };
  };
}
