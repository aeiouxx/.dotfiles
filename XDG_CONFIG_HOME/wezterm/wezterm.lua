local wezterm = require 'wezterm'

local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. ' ] = ' .. dump(v) .. ','
    end
    return s .. '}'
  else
    return tostring(o)
  end
end

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end
config.default_prog = { "pwsh.exe", "-NoLogo" }
-- Window
config.window_decorations = 'RESIZE'
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
-- Misc
config.text_background_opacity = 1.0
config.adjust_window_size_when_changing_font_size = false
config.font = wezterm.font("JetBrains Mono")
config.audible_bell = "Disabled"

local opacity_util = require 'opacity-util'
opacity_util(config)



-- Keymaps
config.leader = { key = ",", mods = "CTRL", timeout_milliseconds = 1500 }
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
  {
    mods = "LEADER",
    key = "a",
    action = wezterm.action.ShowLauncherArgs {
      flags = "FUZZY|DOMAINS",
      title = "Select a domain"
    },
  },
  {
    key = "y",
    mods = "LEADER",
    action = wezterm.action.ActivateCopyMode,
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
