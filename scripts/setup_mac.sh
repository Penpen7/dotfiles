#!/bin/bash -xeu

if [ "$(uname)" != "Darwin" ]; then
  echo "Not macOS!"
  exit 1
fi

defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Show Tab bar in Finder
defaults write com.apple.finder ShowTabView -bool true

# Increase keyboard repeat rate
defaults write KeyRepeat -int 1

## タップしたときクリック
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

## 三本指でドラッグ
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
