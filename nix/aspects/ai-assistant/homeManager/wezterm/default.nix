{
  programs.wezterm.extraConfig = builtins.readFile ./hermes-agent-domain.lua;
}
