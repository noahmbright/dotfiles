-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()
local act = wezterm.action

-- ricing
--config.color_scheme = 'Batman'
config.color_scheme = 'Gruvbox Material (Gogh)'
print(config.font_dirs)
config.font = wezterm.font("MonaspiceXe Nerd Font Propo", { weight = "Bold", stretch = "Normal", style = "Normal" })
config.use_fancy_tab_bar = true
config.window_background_image = ""
config.window_background_image_hsb = {
    hue = 1.0,
    saturation = 1.0,
    brightness = 1.0
}

--config.window_background_gradient ={
--    orientation = {Linear = {angle = -45.0}},
--    colors = {
--        '#0f0c29',
--        '#302b63',
--        '#24243e',
--      },
--}
config.window_background_opacity = .99
--config.window_decorations = "TITLE"
config.inactive_pane_hsb = {
    --hue = .1,
    saturation = .8,
    brightness = .5
}

-- wezterm ls-fonts
-- broken ^^
--config.font = wezterm.font_with_fallback({
--    'Fira Code'
--})

-- launching programs
config.default_cwd = wezterm.home_dir
act.SpawnCommandInNewTab {
    cwd = wezterm.home_dir
}

--keys
config.leader = {
    key = ' ',
    mods = "CTRL"
}
config.keys = {
    {
        key = '|',
        mods = "LEADER",
        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
    },
    {
        key = '-',
        mods = "LEADER",
        action = act.SplitVertical { domain = 'CurrentPaneDomain' }
    },
    {
        key = 'x',
        mods = "LEADER",
        action = act.CloseCurrentPane { confirm = true }
    },
    {
        key = 'h',
        mods = "LEADER",
        action = act.ActivatePaneDirection("Left"),
    },
    {
        key = 'j',
        mods = "LEADER",
        action = act.ActivatePaneDirection("Down"),
    },
    {
        key = 'k',
        mods = "LEADER",
        action = act.ActivatePaneDirection("Up"),
    },
    {
        key = 'l',
        mods = "LEADER",
        action = act.ActivatePaneDirection("Right"),
    },
    {
        key = 'r',
        mods = "LEADER",
        action = act.ActivateKeyTable {
            name = 'resize_pane',
            one_shot = false
        },
    },
    {
        key = 'LeftArrow',
        mods = 'OPT',
        action = act.SendKey {
            key = 'b',
            mods = 'OPT'
        },
    },
    {
        key = 'RightArrow',
        mods = 'OPT',
        action = act.SendKey {
            key = 'f',
            mods = 'OPT'
        },
    }
}



config.key_tables = {
    resize_pane = {
        { key = 'LeftArrow',  action = act.AdjustPaneSize { 'Left', 2 } },
        { key = 'h',          action = act.AdjustPaneSize { 'Left', 2 } },

        { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 2 } },
        { key = 'l',          action = act.AdjustPaneSize { 'Right', 2 } },

        { key = 'UpArrow',    action = act.AdjustPaneSize { 'Up', 2 } },
        { key = 'k',          action = act.AdjustPaneSize { 'Up', 2 } },

        { key = 'DownArrow',  action = act.AdjustPaneSize { 'Down', 2 } },
        { key = 'j',          action = act.AdjustPaneSize { 'Down', 2 } },

        -- Cancel the mode by pressing escape
        { key = 'Escape',     action = 'PopKeyTable' },
    },
}

wezterm.on('update-right-status', function(window, pane)
    local name = window:active_key_table()
    if name then
        name = 'TABLE: ' .. name
    end
    window:set_right_status(name or '')
end
)

--incase I get confused
--config.debug_key_events = true



return config
