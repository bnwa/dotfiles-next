local w = require 'wezterm'
local gui = w.gui

local function dir_exists(path)
  local exists, _ = pcall(w.read_dir, path)
  if not exists then
    return false
  else
    return true
  end
end

local function shell_path()
  local m1_homebrew = "/opt/homebrew"
  local intel_homebrew = "/usr/local/Homebrew"
  local has_m1_homebrew = dir_exists(m1_homebrew)
  local has_intel_homebrew = dir_exists(intel_homebrew)

  if has_intel_homebrew then
    return { "/usr/local/bin/fish", "-l" }
  elseif has_m1_homebrew then
    return { "/opt/homebrew/bin/fish", "-l" }
  else
    return { "/bin/zsh" }
  end
end

local function modal_color_scheme(mode)
  if mode:find 'Dark' then
    return 'melange_dark'
  else
    return 'melange_light'
  end
end

return {
  check_for_updates = false, -- Managed by Homebrew
  color_scheme = modal_color_scheme(gui.get_appearance()),
  default_prog = shell_path(),
  font = w.font {
    family = 'FiraCode Nerd Font',
    weight = "Medium",
    harfbuzz_features = {
      'ss05', -- circular 'at' symbol variant
      'cv30', -- longer 'pipe' symbol
    }
  },
  font_size = 18,
  hide_tab_bar_if_only_one_tab = true,
  initial_cols = 80,
  native_macos_fullscreen_mode = true,
  tab_bar_at_bottom = true,
}
