{ lib, ... }:
{
  programs.wezterm.extraConfig = lib.mkAfter (builtins.readFile ./hermes-agent-domain.lua);
}
