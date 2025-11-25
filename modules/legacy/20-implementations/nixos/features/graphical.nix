{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.features.graphical;
in
{
  config = mkIf cfg.enable {
    # TODO: this needs to be cleaned up
    services = {
      xserver = {
        enable = true;
        displayManager = {
          sessionCommands = ''
            XDG_CURRENT_DESKTOP="X-NIXOS-SYSTEMD-AWARE"
          '';
          lightdm = {
            enable = true;
            greeters = {
              slick.enable = false;
              gtk.enable = true;
            };
            # TODO set this in domain stylix settings
            background = pkgs.nixos-artwork.wallpapers.catppuccin-mocha.gnomeFilePath;
          };
        };
        desktopManager = {
          xfce = {
            enable = true;
            noDesktop = true;
            enableXfwm = false;
            enableWaylandSession = true;
          };
        };
        windowManager.i3 = {
          enable = true;
        };
        videoDrivers =
          if cfg.drivers.nvidia.enable then
            warn "When NVidia driver is enabled no other driver can be enabled at the same time." [ "nvidia" ]
          else
            [
              "modesetting"
              "fbdev"
            ]
            ++ optionals cfg.drivers.displaylink.enable [
              "displaylink"
            ];
      };

      displayManager = {
        defaultSession = "xfce+i3";
      };


      cinnamon = {
        apps.enable = true;
      };
    };

    environment.cinnamon.excludePackages = with pkgs; [
      gnome-terminal
      xed-editor
      gnome-calendar
      gnome-screenshot
    ];

    users.users.${config.my.config.mainUser.name}.extraGroups = [
      "audio"
      "video"
      "input"
    ];

    systemd.user.units."xfce4-notifyd".enable = false;

    # TODO: this should not be enabled by default but do it for now
    hardware.graphics = {
      enable = true;
    };

    # https://nixos.wiki/wiki/Nvidia
    hardware.nvidia = mkIf cfg.drivers.nvidia.enable {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #  version = "570.153.02";
      #  sha256_64bit = "sha256-FIiG5PaVdvqPpnFA5uXdblH5Cy7HSmXxp6czTfpd4bY=";
      #  sha256_aarch64 = "";
      #  openSha256 = "";
      #  settingsSha256 = "sha256-5m6caud68Owy4WNqxlIQPXgEmbTe4kZV2vZyTWHWe+M=";
      #  persistencedSha256 = lib.fakeSha256;
      #};
    };
  };
}
