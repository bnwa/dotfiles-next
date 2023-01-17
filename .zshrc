if [[ ! -d $HOME/.dotfiles ]] {
    if [[ -x $(which git) ]] {
        git clone --separate-git-dir=$HOME/.dotfiles git@github.com:bnwa/dotfiles-next.git $HOME/.dotfiles-tmp
        rm -r $HOME/.dotfiles-tmp
        if [[ -d $HOME/.dotfiles ]] {
            alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
            print "Dotfiles bare git repo installed at ~/.dotfiles"
        }
    } else {
        print "No git executable found -- install git, then source .zshrc or re-login to shell to clone dotfiles"
    }
}

alias ls='ls --color=always'
[[ -d $HOME/.dotfiles ]] && alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

export PS1="%F{blue}%1~%f%F{green} λ%f "
