#!/usr/bin/env bash

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="/etc/X11/xorg.conf"
BACKUP="/etc/X11/xorg.conf.bak"

echo "== NVIDIA Xorg config installer =="
echo "Repo: $REPO_DIR"
echo

# Check root
if [[ $EUID -ne 0 ]]; then
  echo "❌ Please run this script with sudo"
  exit 1
fi

# Backup existing config if present
if [[ -e "$TARGET" && ! -L "$TARGET" ]]; then
  echo "📦 Existing xorg.conf found, creating backup:"
  echo "   $BACKUP"
  mv "$TARGET" "$BACKUP"
fi

# Remove old symlink if it exists
if [[ -L "$TARGET" ]]; then
  echo "🔁 Removing existing symlink"
  rm "$TARGET"
fi

# Create symlink
echo "🔗 Creating symlink:"
echo "   $TARGET -> $REPO_DIR/xorg.conf"
ln -s "$REPO_DIR/xorg.conf" "$TARGET"

echo
echo "✅ Done!"
echo "You can now restart X (logout or reboot)"
