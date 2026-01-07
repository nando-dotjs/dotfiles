#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"
CONFIG="$HOME/.config"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

log() {
    printf "\033[1;32m==>\033[0m %s\n" "$1"
}

backup() {
    local target="$1"
    mkdir -p "$BACKUP"
    mv "$target" "$BACKUP/"
    log "Backup de $(basename "$target") → $BACKUP"
}

link() {
    local src="$1"
    local dst="$2"
    local use_sudo="${3:-false}"

    # Si ya es symlink correcto
    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$src" ]; then
        log "Symlink ya existe: $dst"
        return
    fi

    # Si existe pero no es symlink correcto
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ "$use_sudo" = true ]; then
            sudo mv "$dst" "$BACKUP/"
        else
            backup "$dst"
        fi
    fi

    # Crear symlink
    if [ "$use_sudo" = true ]; then
        sudo ln -sf "$src" "$dst"
    else
        ln -s "$src" "$dst"
    fi
    log "Link: $dst → $src"
}

log "Iniciando instalación de dotfiles"

mkdir -p "$CONFIG"
mkdir -p "$HOME/docker"

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
link "$DOTFILES/suckless/README.md" "$CONFIG/suckless/README.md"
link "$DOTFILES/suckless/install-suckless-symlinks.sh" "$CONFIG/suckless/install-suckless-symlinks.sh"

# -------------------------
# Yazi
# -------------------------
link "$DOTFILES/yazi" "$CONFIG/yazi"

# -------------------------
# Docker Emby
# -------------------------
link "$DOTFILES/docker/emby" "$HOME/docker/emby"

# -------------------------
# Nvidia Xorg config (requiere sudo)
# -------------------------
link "$DOTFILES/nvidia-config-x11/xorg.conf" "/etc/X11/xorg.conf" true

log "Dotfiles instalados correctamente 🎉"
