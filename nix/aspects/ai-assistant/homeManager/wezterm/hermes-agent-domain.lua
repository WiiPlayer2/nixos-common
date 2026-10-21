if config.exec_domains == nil then
  config.exec_domains = { }
end

table.insert(config.exec_domains, wezterm.exec_domain('hermes-agent', function(cmd)
  cmd.args = {
    'hermes',
    '--tui', -- TODO: configure via hermes configuration
  }
  return cmd
end, 'Hermes Agent'))
