local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end


config.default_prog = { "pwsh.exe", "-NoLogo" }
config.font = wezterm.font("JetBrains Mono")
config.use_fancy_tab_bar = false
config.window_background_opacity = 0.75
config.win32_system_backdrop = 'Acrylic'
config.color_scheme = 'Ciapre'
config.text_background_opacity = 1.0
config.window_decorations = 'RESIZE'
config.tab_bar_at_bottom = true

-- Keymaps
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1500 }
config.keys = {
  {
    mods = "LEADER",
    key = "c",
    action = wezterm.action.SpawnTab "CurrentPaneDomain",
  },
  {
    mods = "LEADER",
    key = "x",
    action = wezterm.action {
      CloseCurrentPane = {
        confirm = true,
      },
    },
  },
  {
    mods = "LEADER",
    key = "q",
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    mods = "LEADER",
    key = "n",
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    mods = "LEADER",
    key = "-",
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    mods = "LEADER",
    key = "v",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
  },
  {
    mods = "LEADER",
    key = "s",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
  },
  {
    mods = "LEADER",
    key = "h",
    action = wezterm.action.ActivatePaneDirection "Left"
  },
  {
    mods = "LEADER",
    key = "j",
    action = wezterm.action.ActivatePaneDirection "Down"
  },
  {
    mods = "LEADER",
    key = "k",
    action = wezterm.action.ActivatePaneDirection "Up"
  },
  {
    mods = "LEADER",
    key = "l",
    action = wezterm.action.ActivatePaneDirection "Right"
  },
  {
    mods = "LEADER",
    key = "u",
    action = wezterm.action.AdjustPaneSize { "Left", 5 }
  },
  {
    mods = "LEADER",
    key = "p",
    action = wezterm.action.AdjustPaneSize { "Right", 5 }
  },
  {
    mods = "LEADER",
    key = "i",
    action = wezterm.action.AdjustPaneSize { "Down", 5 }
  },
  {
    mods = "LEADER",
    key = "o",
    action = wezterm.action.AdjustPaneSize { "Up", 5 }
  },
}
for i = 1, 9 do
  table.insert(config.keys, {
    mods = "LEADER",
    key = tostring(i),
    action = wezterm.action.ActivateTab(i - 1),
  })
end


wezterm.on("update-right-status", function(window, _)
  local left_status = ""
  local left_arrow = ""
  if window:leader_is_active() then
    left_status = " " .. utf8.char(0x1FAE6)
    if window:active_tab():tab_id() ~= 0 then
      left_arrow = " " .. utf8.char(0xE0B2)
    end
  end
  window:set_left_status(wezterm.format {
    { Background = { Color = "#000000" } },
    { Foreground = { Color = "#c0c0c0" } },
    { Text = left_status },
    { Foreground = { Color = "#333333" } },
    { Text = left_arrow },
  })
end)
return config
