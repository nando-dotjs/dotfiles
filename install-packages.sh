#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
PKGDIR="$DOTFILES/packages"

APT_BASE="$PKGDIR/apt-base.txt"
BREW_PKGS="$PKGDIR/brew.txt"

echo "==> Installing APT base packages"

if [[ -f "$APT_BASE" ]]; then
  sudo apt update
  xargs sudo apt install -y < "$APT_BASE"
else
  echo "⚠️  apt-base.txt not found, skipping APT packages"
fi

echo
echo "==> Checking Homebrew"

if ! command -v brew >/dev/null; then
  echo "🍺 Homebrew not found, installing..."

  sudo apt update
  sudo apt install -y build-essential procps curl file git

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -d /home/linuxbrew/.linuxbrew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  brew doctor || true
  brew install gcc
else
  echo "🍺 Homebrew already installed"
fi

echo
echo "==> Installing Homebrew packages"

if command -v brew >/dev/null && [[ -f "$BREW_PKGS" ]]; then
  xargs brew install < "$BREW_PKGS"
else
  echo "⚠️  brew.txt not found or brew unavailable, skipping brew packages"
fi

echo
echo "✅ Package installation complete"
