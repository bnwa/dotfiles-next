function colorscheme
	if test -n "$(echo (which npx))" -a -n "$ALACRITTY_WINDOW_ID"
		npx alacritty-themes $argv
	end
end
