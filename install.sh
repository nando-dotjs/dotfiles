#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"
CONFIG="$HOME/.config"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

log() {
  printf "\033[1;32m==>\033[0m %s\n" "$1"
}

backup() {
  mkdir -p "$BACKUP"
  mv "$1" "$BACKUP/"
  log "Backup de $(basename "$1") → $BACKUP"
}

link() {
  local src="$1"
  local dst="$2"

  if [ -L "$dst" ]; then
    log "Symlink ya existe: $dst"
    return
  fi

  if [ -e "$dst" ]; then
    backup "$dst"
  fi

  ln -s "$src" "$dst"
  log "Link: $dst → $src"
}

log "Iniciando instalación de dotfiles"

mkdir -p "$CONFIG"

# -------------------------
# Bash
# -------------------------
link "$DOTFILES/bashrc" "$HOME/.bashrc"
link "$DOTFILES/bash" "$CONFIG/bash"

# -------------------------
# Flameshot
# -------------------------
link "$DOTFILES/flameshot" "$CONFIG/flameshot"

# -------------------------
# Suckless stack
# -------------------------
mkdir -p "$CONFIG/suckless"

for dir in dunst dwm picom rofi scripts slstatus st sxhkd tabbed wallpaper; do
  link "$DOTFILES/suckless/$dir" "$CONFIG/suckless/$dir"
done

# README y script (opcional, pero prolijo)
link "$DOTFILES/suckless/README.md" "$CONFIG/suckless/README.md"
link "$DOTFILES/suckless/install-suckless-symlinks.sh" \
     "$CONFIG/suckless/install-suckless-symlinks.sh"

log "Dotfiles instalados correctamente 🎉"
