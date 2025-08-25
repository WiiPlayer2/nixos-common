local wezterm = require 'wezterm'
local distrobox = require "cfg/_distrobox"
local config = wezterm.config_builder()

-- config.font_size = 10.0
-- config.font = wezterm.font 'Monospace Regular'

-- config.window_background_opacity = 0.8
-- config.text_background_opacity = 0.8

-- for some reason needed to avoid fonts not rendering correctly
-- see https://github.com/wez/wezterm/issues/5990
config.front_end = "OpenGL"

-- for some reason WezTerm does not launch zsh on kiryu (maybe due to AD login)
config.default_prog = { 'zsh' }
config.hide_tab_bar_if_only_one_tab = true
config.mux_enable_ssh_agent = false

config.exec_domains = {}
-- distrobox.add_distrobox_domains(config.exec_domains)
config.background = {
    {
        source = {
            File = os.getenv( "HOME" ) .. '/Dropbox/Bilder/Wallpaper/untagged/Touhou/Th06/Sakuya Izayoi/12501205.png',
        },
        hsb = { brightness = 0.1 }, -- TODO: fix this to apply proper styled color etc., but first the background image needs to be cut out
        horizontal_align = "Right",
    },
}

-- local current_domain = config.default_domain
-- wezterm.on('update-status', function(window, pane)
--     -- if pane:get_domain_name() == current_domain then
--     --     return
--     -- end

--     current_domain = pane:get_domain_name()
--     window:set_right_status(current_domain)
    
--     local distrobox_name = distrobox.get_distrobox_name(current_domain)
--     if distrobox_name then
--         window:set_config_overrides({
--             background = {
--                 {
--                     source = {
--                         File = os.getenv( "HOME" ) .. '/Dropbox/Bilder/Wallpaper/untagged/Touhou/Th06/Sakuya Izayoi/aHDMLie.jpg',
--                     },
--                     hsb = { brightness = 0.1 },
--                     horizontal_align = "Right",
--                 }
--             }
--         })
--     else
--         window:set_config_overrides()
--     end
-- end)

return config
