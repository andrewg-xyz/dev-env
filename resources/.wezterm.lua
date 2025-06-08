local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.default_prog = {"/bin/zsh", "-l", "-i"}

config.font_size = 18
config.color_scheme = "Dracula (Official)"
-- config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"


config.keys = {
    {
        key = 'm',
        mods = 'CTRL',
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = '|',
        mods = 'CMD|SHIFT',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = '-',
        mods = 'CMD|SHIFT',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'LeftArrow',
        mods = 'CMD|SHIFT',
        action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
        key = 'RightArrow',
        mods = 'CMD|SHIFT',
        action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
        key = 'UpArrow',
        mods = 'CMD|SHIFT',
        action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
        key = 'DownArrow',
        mods = 'CMD|SHIFT',
        action = wezterm.action.ActivatePaneDirection 'Down',
    },
}

return config



