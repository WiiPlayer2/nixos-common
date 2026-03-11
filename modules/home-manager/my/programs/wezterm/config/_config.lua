local wezterm = require 'wezterm'

local function create_background_cfg(vars, optional_gradient_color)
  local bg_src = {}
  if optional_gradient_color ~= nil then
    bg_src["Gradient"] = {
      orientation = "Horizontal",
      colors = {
        vars.base_color,
        vars.base_color,
        vars.base_color,
        optional_gradient_color,
      },
      noise = 0,
    }
  else
    bg_src["Color"] = vars.base_color
  end

  local background = {
    {
      source = bg_src,
      height = "100%",
      width = "100%",
    },
    {
      source = {
        File = vars.bg_file,
      },
      opacity = 0.5,
      horizontal_align = "Right",
      vertical_align = "Bottom",
      height = "Contain",
      width = "Contain",
      repeat_x = "NoRepeat",
      repeat_y = "NoRepeat",
    },
  }

  return background
end

local function set_background(window, vars, optional_gradient_color)
  local background = create_background_cfg(vars, optional_gradient_color)

  window:set_config_overrides({
    background = background,
  })
end

local function apply_config(config, vars)
  config.hide_tab_bar_if_only_one_tab = true
  config.mux_enable_ssh_agent = false

  config.exec_domains = {}
  -- distrobox.add_distrobox_domains(config.exec_domains)

  config.background = create_background_cfg(vars, nil)

  wezterm.on('update-status', function(window, pane)
    local info = pane:get_foreground_process_info()
    if info then
      window:set_right_status(
        tostring(info.pid) .. ' ' .. info.name
      )

      set_background(window, vars, vars.processes[info.name])
    else
      window:set_right_status('')
      set_background(window, vars, nil)
    end
  end)
end

return apply_config
