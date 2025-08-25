{ lib
, config
, flakeRoot
, ...
}:
with lib;
let
  cfg = config.my.config;
in
{
  # Set your time zone.
  time.timeZone = cfg.time.timeZone;

  # Select internationalisation properties.
  i18n.defaultLocale = cfg.i18n.language;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = cfg.i18n.formats;
    LC_IDENTIFICATION = cfg.i18n.formats;
    LC_MEASUREMENT = cfg.i18n.formats;
    LC_MONETARY = cfg.i18n.formats;
    LC_NAME = cfg.i18n.formats;
    LC_NUMERIC = cfg.i18n.formats;
    LC_PAPER = cfg.i18n.formats;
    LC_TELEPHONE = cfg.i18n.formats;
    LC_TIME = cfg.i18n.formats;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = cfg.keyboard.layout;
    variant = "";
  };

  # Configure console keymap
  console.keyMap = cfg.keyboard.layout;

  users.users = {
    root = {
      ignoreShellProgramCheck = true;
      shell = cfg.defaultShell;
    };

    "${cfg.mainUser.name}" = {
      description = mkIf (cfg.mainUser.description != null) cfg.mainUser.description;

      extraGroups = [
        "wheel"
      ];

      ignoreShellProgramCheck = true;
      shell = cfg.defaultShell;
    };
  };

  environment.shells = [
    cfg.defaultShell
  ];

  nix.settings = {
    trusted-users = [
      "@wheel"
    ];
  } // cfg.nix.settings;

  networking.hostName = cfg.hostname;

  age.rekey = {
    hostPubkey = mkIf (cfg.hostPubkey != null) cfg.hostPubkey;
    masterIdentities = [
      {
        identity = flakeRoot + "/secrets/identities/yubikey.pub";
        pubkey = "age1yubikey1qfphf9vkgzv3kt80nuz5dpeuchmxa6tcsaypkmzvl6ngtnd34jmysqm4vaz";
      }
    ];
    extraEncryptionPubkeys = [
      "age1pvdtjne22xgkra7wh9nz6m7dtcjmfn3qx5tyu3gzpqmaey4e2s4qj4pa3s"
    ];
    storageMode = "local";
    localStorageDir = flakeRoot + "/secrets/rekeyed/${config.my.meta.configurationNames.nixos}";
  };
}
