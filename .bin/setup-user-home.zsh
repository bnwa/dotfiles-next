echo "Setting up User configuration"
echo "-----------------------------"

if [[ ! -d "$HOME/.dotfiles" ]]; then
  cd $HOME
  git clone --separate-git-dir=$HOME/.dotfiles https://github.com/bnwa/dotfiles-next.git dot-tmp
  rm -rf ./dot-tmp
  git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout .
fi

