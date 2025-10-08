{
  imports = [
    ./nixOnDroid
  ];

  # nixpkgs.config.allowUnfree = true;

  # https://github.com/nix-community/nix-on-droid
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Set your time zone
  time.timeZone = "Europe/Berlin";
}
