alias l="ls -A --color=always"
[[ -d $HOME/.dotfiles ]] && alias config="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

export PS1="%F{blue}%1~%f%F{green} λ%f "
