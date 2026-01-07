#!/bin/bash

# Paso 1: Instalar openfortivpn
echo "Instalando openfortivpn..."
sudo apt update
sudo apt install -y openfortivpn

# Paso 2: Crear el script para la VPN
echo "Creando el archivo /usr/local/bin/vpnzureo..."
sudo bash -c 'cat > /usr/local/bin/vpnzureo <<EOF
#!/bin/bash
sudo openfortivpn megasa.zureodns.com:10443 --saml-login --trusted-cert e299b7bc682813fda4bd53805eb69315678eb7d4e22bf9a43018a31adf54ca12
EOF'

# Paso 3: Dar permisos de ejecución al archivo vpnzureo
echo "Dando permisos de ejecución al archivo vpnzureo..."
sudo chmod +x /usr/local/bin/vpnzureo

# Paso 4: Configurar el montaje SMB
# Configura estas variables según tu entorno
SMB_SERVER="192.168.25.5"                  # IP del servidor SMB
SMB_SHARE="temporal/ZServer/Personales/Fernando Pérez"  # Ruta SMB compartida
MOUNT_DIR="/mnt/fernando_perez"            # Punto de montaje local
USER="usuario"                             # Usuario para autenticar
PASSWORD="usuario"                         # Contraseña del usuario

# Verifica si el directorio de montaje existe, si no lo crea
if [ ! -d "$MOUNT_DIR" ]; then
    echo "El directorio $MOUNT_DIR no existe. Creándolo..."
    sudo mkdir -p "$MOUNT_DIR"
else
    echo "El directorio $MOUNT_DIR ya existe."
fi

# Monta la carpeta SMB
echo "Montando $SMB_SHARE en $MOUNT_DIR..."
sudo mount -t cifs "//${SMB_SERVER}/${SMB_SHARE}" "$MOUNT_DIR" -o username="$USER",password="$PASSWORD,vers=3.0"

# Verifica si el montaje fue exitoso
if mountpoint -q "$MOUNT_DIR"; then
    echo "Montaje exitoso en $MOUNT_DIR"
else
    echo "Error al montar $SMB_SHARE"
    exit 1
fi

# Preguntar si quieres agregar el montaje al archivo fstab para montar automáticamente en el inicio
read -p "¿Quieres montar esta carpeta automáticamente al iniciar el sistema? (s/n): " ADD_TO_FSTAB

if [ "$ADD_TO_FSTAB" == "s" ]; then
    # Backup del archivo fstab
    sudo cp /etc/fstab /etc/fstab.bak

    # Agregar la entrada al archivo fstab
    echo "//${SMB_SERVER}/${SMB_SHARE} $MOUNT_DIR cifs username=$USER,password=$PASSWORD,vers=3.0 0 0" | sudo tee -a /etc/fstab

    echo "Se ha añadido el montaje a /etc/fstab. El recurso se montará automáticamente al reiniciar."
fi

echo "Script completado."