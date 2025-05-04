#!/bin/zsh
echo "Setting up Homebrew"
echo "-------------------"

tools=(
  "bat"
  "bottom"
  "cmake"
  "delta"
  "eza"
  "fd"
  "ffmpeg"
  "fish"
  "fnm"
  "fzf"
  "git"
  "glow"
  "httpie"
  "imagemagick"
  "jq"
  "lazydocker"
  "lazygit"
  "make"
  "maven"
  "neovim"
  "node"
  "pandoc"
  "poppler"
  "resvg"
  "ripgrep"
  "rsync"
  "rust"
  "sevenzip"
  "sqlite"
  "subversion"
  "tldr"
  "tmux"
  "trash"
  "tree"
  "yazi"
  "zellij"
  "zoxide"
)
taps=(
  "oven-sh/bun"
)
casks=(
  "font-fira-code-nerd-font"
  "ghostty"
  "zulu@17"
  "zulu@21"
  "adoptopenjdk8"
)

xcode-select -p &>/dev/null || {
  echo "XCode Command Line Tools are not installed; installing now..."
  xcode-select --install
}

if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
brew update
echo "Ensuring Homebrew taps are tapped..."
for tap in $taps; do
  brew tap $tap
done

echo "Install Homebrew tools..."
for tool in $tools; do
  brew install $tool
done

echo "Install Homebrew casks..."
for cask in $casks; do
  brew install --cask $cask
done

brew cleanup
