if [[ ! -d $HOME/.dotfiles ]] {
    if [[ -x ${which git} ]] {
        git clone --separate-git-dir=$HOME/.dotfiles git@github.com:bnwa/dotfiles-next.git $HOME/.dotfiles-tmp
        rm -r $HOME/.dotfiles-tmp
    } else {
        print "No git executable found -- install git, then source .zshrc or re-login to shell to clone dotfiles"
    }
}

[[ -d $HOME/.dotfiles ]] && alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
