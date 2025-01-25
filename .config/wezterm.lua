local wezterm = require 'wezterm'

return {
  -- General configuration
  default_prog = { "pwsh.exe", "-NoLogo" },
  -- Font
  font = wezterm.font("JetBrains Mono"),
  -- Appearance
  use_fancy_tab_bar = false,
  window_background_opacity = 0.85,
  win32_system_backdrop = 'Acrylic',
  color_scheme = 'zenwritten_dark',
  text_background_opacity = 1.0,
  window_decorations = 'RESIZE',
}
