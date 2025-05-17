local wezterm = require 'wezterm'


return function(config)
  local fallback = {
    fe = config.front_end,
    wpp = config.webgpu_power_preference,
    wbo = config.window_background_opacity,
    wsb32 = config.win32_system_backdrop,
    wpa = config.webgpu_preferred_adapter
  }

  local function restore()
    config.front_end = fallback.fe
    config.webgpu_power_preference = fallback.wpp
    config.window_background_opacity = fallback.wbo
    config.win32_system_backdrop = fallback.wsb32
    config.webgpu_preferred_adapter = fallback.wpa
  end

  local success, err = pcall(function()
    local gpus = wezterm.gui.enumerate_gpus()
    local selected_adapter = nil
    local function adapter_prio(adapter)
      local backend = adapter.backend
      local type = adapter.device_type
      if backend ~= 'Gl' then
        wezterm.log_error("Incorrect backend: " .. backend)
        return 0
      end
      local prio = {
        DiscreteGpu = 3,
        IntegratedGpu = 2,
        Cpu = 1
      }
      return prio[type] or 0
    end

    local highest = 0
    for _, gpu in ipairs(gpus) do
      local priority = adapter_prio(gpu)
      if priority > highest then
        selected_adapter = gpu
        highest = priority
      end
    end

    if not selected_adapter then
      error("No suitable GPU adapter found with backend 'Gl', opacity would cause artefacts :(")
    end

    -- Success
    config.front_end = 'WebGpu'
    config.webgpu_power_preference = 'HighPerformance'
    config.window_background_opacity = 0.65
    config.win32_system_backdrop = 'Acrylic'
    config.webgpu_preferred_adapter = selected_adapter
    wezterm.log_info("WebGpu adapter set to:")
    for key, value in pairs(selected_adapter) do
      wezterm.log_info("\t" .. key .. ": " ..tostring(value))
    end
  end)

  if not success then
    wezterm.log_error("Opacity setup unsuccessful: " .. err)
    restore()
  end
end
