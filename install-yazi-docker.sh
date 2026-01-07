#!/usr/bin/env bash
# install-yazi-docker.sh
# Script para instalar Yazi y Docker en Debian

set -euo pipefail

# Función para imprimir secciones
echo_section() {
    echo
    echo "==> $1"
    echo
}

# ------------------------------
# Instalar Yazi
# ------------------------------
echo_section "Agregando repositorio de Yazi..."

# Añadir clave GPG de Yazi
curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | \
    sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg

# Añadir repositorio según la versión de Debian
DISTRO=$(lsb_release -sc 2>/dev/null || echo "stable")
echo "deb https://debian.griffo.io/apt $DISTRO main" | \
    sudo tee /etc/apt/sources.list.d/debian.griffo.io.list >/dev/null

echo_section "Actualizando lista de paquetes..."
sudo apt update

echo_section "Instalando Yazi..."
sudo apt install -y yazi

echo_section "Verificando instalación de Yazi..."
yazi --version

# ------------------------------
# Instalar Docker
# ------------------------------
echo_section "Instalando dependencias para Docker..."
sudo apt install -y ca-certificates curl

echo_section "Creando keyrings para Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo_section "Agregando repositorio de Docker..."
sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

echo_section "Actualizando lista de paquetes para Docker..."
sudo apt update

echo_section "Instalando Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ------------------------------
# Configuración de grupo Docker
# ------------------------------
echo_section "Configurando permisos de usuario para Docker..."
if ! getent group docker >/dev/null; then
    sudo groupadd docker
fi

sudo usermod -aG docker "$USER"

echo_section "Para aplicar los cambios de grupo, cierra sesión y vuelve a iniciar, o ejecuta:"
echo "  newgrp docker"

echo_section "Instalación completada. Yazi y Docker están listos."