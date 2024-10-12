#!/bin/zsh
echo "Setting up macos Finder defaults"
echo "--------------------------------"

echo "Configured Finder to hide recent tags"
defaults write com.apple.finder "ShowRecentTags" -int 0

echo "Configured Finder to hide status bar"
defaults write com.apple.finder "ShowStatusBar" -int 0

echo "Configured Finder to show path bar"
defaults write com.apple.finder "ShowPathbar" -int 1

echo "Configured Finder to show path bar"
defaults write com.apple.finder "ShowPathbar" -int 1

echo "Configured Finder to use current directory as default search scope"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Configured Finder default GroupBy to None"
defaults write com.apple.finder FXPrefferedGroupBy -string "None"

echo "Configured Finder default ViewStyle to Columns"
# Columns -> clmv | List -> Nslv | Gallery -> glyv | Icon -> icnv
defaults write com.apple.finder FXPrefferedViewStyle -string "clmv"

echo "Configured Appearance to switch between Dark/Light mode automatically"
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -int 1

