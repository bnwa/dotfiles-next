[[ -d $HOME/.dotfiles ]] && alias config="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
[[ -x $(which bat) ]] && alias cat=bat
[[ -x $(which eza) ]] && alias ls=eza
[[ -x $(which trash) ]] && alias rm="trash -vF"
[[ -x $(which delta) ]] && alias diff=delta
alias l="ls -A --color=always"

if [[ -x $(which bat) ]]; then export MANPAGER="sh -c 'col -bx | bat -l man -p'" ; fi
export PS1="%F{blue}%1~%f%F{green} λ%f "
