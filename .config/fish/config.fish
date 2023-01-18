fish_vi_key_bindings

if test ! -d "$HOME/.dotfiles"
	if -x /usr/bin/git -o -x /usr/local/bin/git
		git clone --separate-git-dir=$HOME/.dotfiles git@github.com:bnwa/dotfiles-next.git $HOME/.dotfiles-tmp
		rm -r $HOME/.dotfiles-tmp
    echo "Successfully cloned dotfiles, can now safely use config command"
	else
		echo "No git executable found -- install and re-run shell config to clone missing dotfiles"
end
