function config
	if test -d $HOME/.dotfiles
		git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
	else
		echo "Directory not found: ~/.dotfiles -- Clone repo before using config command"
	end
end
