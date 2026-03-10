local wezterm = require 'wezterm'

local function apply_config(config, vars)
  config.hide_tab_bar_if_only_one_tab = true
  config.mux_enable_ssh_agent = false

  config.exec_domains = {}
  -- distrobox.add_distrobox_domains(config.exec_domains)

  config.background = {
    {
      source = {
        Color = vars.base_color,
      },
      height = "100%",
      width = "100%",
    },
    {
      source = {
        File = vars.bg_file,
      },
      opacity = 0.5,
      horizontal_align = "Right",
      height = "Contain",
      width = "Contain",
    },
  }

  wezterm.on('update-status', function(window, pane)
    local info = pane:get_foreground_process_info()
    if info then
      window:set_right_status(
        tostring(info.pid) .. ' ' .. info.name
      )
    else
      window:set_right_status('')
    end
  end)
end

return apply_config
