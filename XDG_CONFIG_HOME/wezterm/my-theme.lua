local wezterm = require("wezterm")

return function(config)
	-- Window
	config.window_decorations = "RESIZE"
	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = true

	-- Misc
	config.text_background_opacity = 1.0
	config.adjust_window_size_when_changing_font_size = false
	config.font = wezterm.font("JetBrains Mono")
	config.audible_bell = "Disabled"
	config.hide_tab_bar_if_only_one_tab = true
end
