# Dotfiles

Configuración personal para Linux (Debian-based), pensada para poder levantar un entorno completo en una PC nueva de forma rápida y reproducible.

Incluye:
- Configuración de Bash
- Configs en `~/.config` (suckless, yazi, flameshot, etc.)
- Scripts de instalación
- Listado de paquetes APT y Homebrew

---

## 📦 Instalación en una PC nueva

Clonar el repositorio **directamente en el home**:

```bash
cd ~
git clone https://github.com/nando-dotjs/dotfiles.git

Entrar al directorio y dar permisos de ejecución a los scripts:
cd ~/dotfiles
chmod +x install.sh install-packages.sh

Instalar paquetes base (APT y Homebrew si corresponde):
./install-packages.sh
./install.sh
```

