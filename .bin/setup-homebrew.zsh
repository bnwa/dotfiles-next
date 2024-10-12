#!/bin/zsh
echo "Setting up Homebrew"
echo "-------------------"

tools=(
  "bat",
  "bottom",
  "cmake",
  "fd",
  "ffmpeg@6",
  "fish",
  "fnm",
  "git",
  "glow",
  "httpie",
  "jq",
  "lazygit",
  "maven",
  "neovim",
  "pandoc",
  "ripgrep",
  "sqlite",
  "subversion",
  "tdlr",
  "tmux",
  "trash",
  "tree",
  "zellij",
  "zoxide"
)
taps=(
  "homebrew/cask-fonts",
  "homebrew/cask-versions",
  "mdogan/zulu",
  "over-sh/bun"
)
casks=(
  "font-fira-code-nerd-font",
  "wezterm",
  "zulu-jdk17",
  "zulu-jdk8"
)

xcode-select -p &>/dev/null || {
  echo "XCode Command Line Tools are not installed; installing now..."
  xcode-select --install
}

if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
echo "Ensuring Homebrew taps are tapped..."
for tap in "${taps[@]}"; do
  brew tap "$tap"
done

echo "Install Homebrew tools..."
for tool in "${tools[@]}"; do
  brew install "$tool"
done

echo "Install Homebrew casks..."
for cask in "${casks[@]}"; do
  brew install "$cask"
done

brew cleanup
