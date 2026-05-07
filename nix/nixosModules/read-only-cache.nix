_:
{ config, ... }:
{
  nix.settings = {
    substituters = [
      # https://cache.nixos.org/ -> priority: 40
      "https://nix-cache.web.home.dark-link.info/default?priority=50"
    ];
    trusted-public-keys = [
      "default:i+DpqCttxFaYK7GOCXcVIjbfXogWSIc01D664rdBdH8="
    ];
    netrc-file = config.age.secrets.nix-netrc.path;
  };
}
