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
  "ffmpeg@6"
  "fish"
  "fnm"
  "fzf"
  "git"
  "glow"
  "httpie"
  "jq"
  "lazydocker"
  "lazygit"
  "make"
  "maven"
  "neovim"
  "node"
  "pandoc"
  "ripgrep"
  "rust"
  "sqlite"
  "subversion"
  "tldr"
  "tmux"
  "trash"
  "tree"
  "zellij"
  "zoxide"
)
taps=(
  "mdogan/zulu"
  "oven-sh/bun"
)
casks=(
  "font-fira-code-nerd-font"
  "ghostty"
  "zulu-jdk17"
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
