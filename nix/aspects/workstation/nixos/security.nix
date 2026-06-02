{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    efibootmgr
  ];

  security = {
    polkit.enable = true;
    pam.services = {
      dms-greeter = {
        fprintAuth = false;
        u2f.enable = false;
      };
      greetd = {
        fprintAuth = false;
        u2f.enable = false;
      };
    };
    sudo.extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/efibootmgr --bootnext [0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/efibootmgr --delete-bootnext";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  services.udev.extraRules = ''
    ACTION=="remove",\
      ENV{ID_BUS}=="usb",\
      ENV{ID_MODEL_ID}=="0407",\
      ENV{ID_VENDOR_ID}=="1050",\
      ENV{ID_VENDOR}=="Yubico",\
      RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';
}
