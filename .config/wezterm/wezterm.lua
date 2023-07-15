local w = require 'wezterm'
local gui = w.gui
local home = os.getenv('HOME')

local function modal_color_scheme(mode)
  if mode:find 'Dark' then
    return 'Tokyo Night Storm'
  else
    return 'Tokyo Night Day'
  end
end

w.on('window-focus-changed', function(win, pane)
  w.reload_configuration() -- re-evaluate color_scheme
end
)

return {
  check_for_updates = false, -- Managed by Homebrew
  color_scheme = modal_color_scheme(gui.get_appearance()),
  color_scheme_dirs = color_scheme_dirs,
  default_prog = { '/opt/homebrew/bin/fish', '-l' },
  font = w.font {
    family = 'FiraCode Nerd Font',
    weight = 450, -- Retina
    harfbuzz_features = {
      'ss05', -- circular 'at' symbol variant
      'cv30', -- longer 'pipe' symbol
    }
  },
  font_size = 16,
  hide_tab_bar_if_only_one_tab = true,
  native_macos_fullscreen_mode = true,
}
