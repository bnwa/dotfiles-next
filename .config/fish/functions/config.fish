function config
  set -l cmd $argv[1]

  if not test -d $HOME/.dotfiles
	  echo "Directory not found: ~/.dotfiles -- Clone repo before using config command"
    return 1
  end

  switch $cmd
    case ls
      git --git-dir=$HOME/.dotfiles --work-tree=$HOME ls-files $argv[2..-1]
    case e
      set -l target $argv[2]
      switch $target
        case nvim
          nvim --cmd 'cd ~/.config/nvim' ~/.config/nvim/{*,**/*}.lua
        case wez
          nvim --cmd 'cd ~/.config/wezterm' ~/.config/wezterm/{*,**/*}.lua
        case fish
          nvim --cmd 'cd ~/.config/fish' ~/.config/fish/{*,**/*}.fish
        case zel
          nvim --cmd 'cd ~/.config/zellij' ~/.config/zellij/{*,**/*}.kdl
        case tmux
          nvim --cmd 'cd ~/.config/tmux' ~/.config/tmux/*
        case git
          nvim --cmd 'cd ~/.config/git' ~/.config/git/{*,**/*}
        case '*'
          echo "Unknown argument to 'e' encountered:" $target
          return 1
      end
    case '*'
		  git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
  end
end
