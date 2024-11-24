-- Sources:
-- * https://alexplescan.com/posts/2024/08/10/wezterm/

-- Pull in the wezterm API
local wezterm = require("wezterm")
local projects = require("projects")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font("Monaspace Neon")
config.font_size = 16.0
config.scrollback_lines = 5000
config.line_height = 1.0
-- config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "INTEGRATED_BUTTONS"
config.native_macos_fullscreen_mode = true

config.default_prog = { "/opt/homebrew/bin/fish", "-l" }

config.force_reverse_video_cursor = true

local kanawanga_light = {
	foreground = "#545464",
	background = "#f2ecbc",

	cursor_bg = "#43436c",
	cursor_fg = "#43436c",
	cursor_border = "#43436c",

	selection_fg = "#43436c",
	selection_bg = "#9fb5c9",

	scrollbar_thumb = "#b5cbd2",
	split = "#b5cbd2",

	ansi = {
		"#1F1F28",
		"#c84053",
		"#6f894e",
		"#77713f",
		"#4d699b",
		"#b35b79",
		"#597b75",
		"#545464",
	},

	brights = {
		"#8a8980",
		"#d7474b",
		"#6e915f",
		"#836f4a",
		"#6693bf",
		"#624c83",
		"#5e857a",
		"#43436c",
	},

	indexed = {
		[16] = "#e98a00", -- extended color 1
		[17] = "#e82424", -- extended color 2
	},

	tab_bar = {
		background = "#e4d794",

		active_tab = {
			bg_color = "#b35b79",
			fg_color = "#f2ecbc",
		},

		inactive_tab = {
			bg_color = "#a6a69c",
			fg_color = "#f2ecbc",
		},

		inactive_tab_hover = {
			bg_color = "#9fb5c9",
			fg_color = "#43436c",
			italic = true,
		},

		new_tab = {
			bg_color = "#b35b79",
			fg_color = "#f2ecbc",
		},

		new_tab_hover = {
			bg_color = "#9fb5c9",
			fg_color = "#43436c",
			italic = true,
		},
	},
}
local kanawanga_dark = {
	foreground = "#dcd7ba",
	background = "#1f1f28",

	cursor_bg = "#c8c093",
	cursor_fg = "#c8c093",
	cursor_border = "#c8c093",

	selection_fg = "#c8c093",
	selection_bg = "#2d4f67",

	scrollbar_thumb = "#16161d",
	split = "#16161d",

	ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
	brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
	indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
}

local current_scheme = 1
local function themeCycler(window, _)
	local schemes = { kanawanga_dark, kanawanga_light }
	local overrides = window:get_config_overrides() or {}
	current_scheme = current_scheme % #schemes + 1
	overrides.colors = schemes[current_scheme]
	window:set_config_overrides(overrides)
end
config.colors = kanawanga_dark

-- kanagawa-dragon colorscheme:
-- colors = {
-- 	foreground = "#c5c9c5",
-- 	background = "#181616",
--
-- 	cursor_bg = "#C8C093",
-- 	cursor_fg = "#C8C093",
-- 	cursor_border = "#C8C093",
--
-- 	selection_fg = "#C8C093",
-- 	selection_bg = "#2D4F67",
--
-- 	scrollbar_thumb = "#16161D",
-- 	split = "#16161D",
--
-- 	ansi = {
-- 		"#0D0C0C",
-- 		"#C4746E",
-- 		"#8A9A7B",
-- 		"#C4B28A",
-- 		"#8BA4B0",
-- 		"#A292A3",
-- 		"#8EA4A2",
-- 		"#C8C093",
-- 	},
-- 	brights = {
-- 		"#A6A69C",
-- 		"#E46876",
-- 		"#87A987",
-- 		"#E6C384",
-- 		"#7FB4CA",
-- 		"#938AA9",
-- 		"#7AA89F",
-- 		"#C5C9C5",
-- 	},
-- },

local function resize_pane(key, direction)
	return {
		key = key,
		action = wezterm.action.AdjustPaneSize({ direction, 3 }),
	}
end

config.key_tables = {
	resize_panes = {
		resize_pane("j", "Down"),
		resize_pane("k", "Up"),
		resize_pane("h", "Left"),
		resize_pane("l", "Right"),
	},
}

config.leader = { key = "b", mods = "CMD", timeout_milliseconds = 2000 }
config.keys = {
	-- ... add these new entries to your config.keys table
	{
		key = '"',
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "%",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		-- I like to use vim direction keybindings, but feel free to replace
		-- with directional arrows instead.
		key = "j", -- or DownArrow
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k", -- or UpArrow
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "h", -- or LeftArrow
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l", -- or RightArrow
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	-- ... remove the yucky keybinding from above and replace it with this
	{
		key = "r",
		mods = "LEADER",
		-- Activate the `resize_panes` keytable
		action = wezterm.action.ActivateKeyTable({
			name = "resize_panes",
			-- Ensures the keytable stays active after it handles its
			-- first keypress.
			one_shot = false,
			-- Deactivate the keytable after a timeout.
			timeout_milliseconds = 1000,
		}),
	},
	{
		key = "p",
		mods = "LEADER",
		-- Present in to our project picker
		action = projects.choose_project(),
	},
	{
		key = "f",
		mods = "LEADER",
		-- Present a list of existing workspaces
		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{
		key = "c",
		mods = "LEADER",
		-- Cycle themes
		action = wezterm.action_callback(themeCycler),
	},
}

-- Use random colorschemes for each window
-- {
-- -- Creates a lua table containing the name of every color scheme WezTerm
-- -- ships with.
-- local scheme_names = {}
-- for name, scheme in pairs(wezterm.color.get_builtin_schemes()) do
-- 	table.insert(scheme_names, name)
-- end
--
-- -- When the config for a window is reloaded (i.e. when you save this file
-- -- or open a new window)...
-- wezterm.on("window-config-reloaded", function(window, pane)
-- 	-- Don't proceed if the config has already been overriden, otherwise
-- 	-- we'll enter an infinite loop of neverending colour scheme changes.
-- 	-- If that sounds like your kinda thing, then remove this line ;) - but
-- 	-- don't say you haven't been warned.
-- 	if window:get_config_overrides() then
-- 		return
-- 	end
-- 	-- Pick a random colour scheme name.
-- 	local scheme = scheme_names[math.random(#scheme_names)]
-- 	-- Assign it as an override for this window.
-- 	window:set_config_overrides({ color_scheme = scheme })
-- 	-- And log it for good measure
-- 	wezterm.log_info("Your colour scheme is now: " .. scheme)
-- end)
-- }

-- and finally, return the configuration to wezterm
return config
