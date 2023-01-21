local w = require 'wezterm'
local gui = w.gui

local function modal_color_scheme(mode)
	if mode:find 'Dark' then
		return 'tokyonight'
	else
		return 'Gruvbox Light'
	end
end

return {
	color_scheme = modal_color_scheme(gui.get_appearance()),
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
	
