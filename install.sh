#!/usr/bin/env bash
# ==============================================================================
# rtl8188eu-hotspot-toolkit: Automated System Installer
# Author: Exequiel Echevarria <exemetal@hotmail.com> (ExeDevCentral)
# License: MIT
# ==============================================================================

set -eo pipefail

BOLD="\033[1m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}"
cat << "EOF"
  ____ _____ _     ___  _  ___   ___  _____ _   _ 
 |  _ \_   _| |   / _ \/ |( _ ) ( _ )| ____| | | |
 | |_) || | | |  | (_) | |/ _ \ / _ \|  _| | | | |
 |  _ < | | | |___\__, | | (_) | (_) | |___| |_| |
 |_| \_\|_| |_____| /_/|_|\___/ \___/|_____|\___/ 
          INSTALLER & SYSTEM INTEGRATION
EOF
echo -e "${RESET}"

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: Este instalador requiere privilegios de administrador.${RESET}"
    echo -e "Ejecute: ${BOLD}sudo ./install.sh${RESET}"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KERNEL_VER="$(uname -r)"

echo -e "${BOLD}${CYAN}[1/6] Verificando dependencias del sistema...${RESET}"
MISSING_PKGS=()
for cmd in make gcc bc nmcli; do
    if ! command -v "$cmd" &>/dev/null; then
        MISSING_PKGS+=("$cmd")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    echo -e "${YELLOW}Faltan herramientas esenciales: ${MISSING_PKGS[*]}${RESET}"
    if command -v pacman &>/dev/null; then
        echo -e "Instalando en Arch Linux..."
        pacman -S --needed --noconfirm base-devel bc networkmanager dkms linux-headers
    elif command -v apt-get &>/dev/null; then
        echo -e "Instalando en Debian/Ubuntu..."
        apt-get update && apt-get install -y build-essential bc network-manager dkms "linux-headers-$KERNEL_VER"
    elif command -v dnf &>/dev/null; then
        echo -e "Instalando en Fedora/RHEL..."
        dnf install -y make gcc bc NetworkManager dkms "kernel-devel-$KERNEL_VER"
    else
        echo -e "${RED}Por favor instale manualmente: ${MISSING_PKGS[*]} y cabeceras del kernel.${RESET}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Todas las dependencias base están satisfechas.${RESET}"
fi

echo ""
echo -e "${BOLD}${CYAN}[2/6] Configurando optimizaciones del kernel y blacklist...${RESET}"
install -m 644 "$SCRIPT_DIR/config/8188eu.conf" /etc/modprobe.d/8188eu.conf
install -m 644 "$SCRIPT_DIR/config/blacklist-rtl8xxxu.conf" /etc/modprobe.d/blacklist-rtl8xxxu.conf
install -m 644 "$SCRIPT_DIR/config/99-ip-forward.conf" /etc/sysctl.d/99-ip-forward.conf
sysctl -w net.ipv4.ip_forward=1 >/dev/null
echo -e "${GREEN}✓ Módulo rtl8xxxu bloqueado y ahorro de energía desactivado.${RESET}"

echo ""
echo -e "${BOLD}${CYAN}[3/6] Compilando e instalando el controlador 8188eu...${RESET}"
cd "$SCRIPT_DIR/driver"
make clean >/dev/null 2>&1 || true
make -j"$(nproc)"

if [ ! -f "8188eu.ko" ]; then
    echo -e "${RED}Error fatal: La compilación del módulo falló.${RESET}"
    exit 1
fi

strip --strip-unneeded 8188eu.ko
DEST_DIR="/lib/modules/$KERNEL_VER/kernel/drivers/net/wireless/"
mkdir -p "$DEST_DIR"
install -p -m 644 8188eu.ko "$DEST_DIR"
depmod -a
echo -e "${GREEN}✓ Módulo 8188eu instalado exitosamente para kernel $KERNEL_VER.${RESET}"

echo ""
echo -e "${BOLD}${CYAN}[4/6] Instalando utilidad CLI 'hotspot'...${RESET}"
install -m 755 "$SCRIPT_DIR/bin/hotspot" /usr/local/bin/hotspot
echo -e "${GREEN}✓ Comando 'hotspot' disponible globalmente en /usr/local/bin/hotspot.${RESET}"

echo ""
echo -e "${BOLD}${CYAN}[5/6] Instalando servicio de inicio automático systemd...${RESET}"
install -m 644 "$SCRIPT_DIR/config/hotspot.service" /etc/systemd/system/hotspot.service
systemctl daemon-reload
echo -e "${GREEN}✓ Servicio systemd configurado.${RESET}"

echo ""
echo -e "${BOLD}${CYAN}[6/6] Cargando módulo y activando punto de acceso...${RESET}"
modprobe -r rtl8xxxu 2>/dev/null || true
modprobe 8188eu 2>/dev/null || true

# Configurar conexión NetworkManager por defecto si no existe
if ! nmcli connection show Hotspot &>/dev/null; then
    echo -e "Creando perfil de conexión Hotspot en NetworkManager..."
    nmcli connection add type wifi ifname wlan0 con-name Hotspot autoconnect no ssid "Red-Exeq-WiFi"
    nmcli connection modify Hotspot 802-11-wireless.mode ap 802-11-wireless.band bg 802-11-wireless.channel 6
    nmcli connection modify Hotspot 802-11-wireless-security.key-mgmt wpa-psk 802-11-wireless-security.proto rsn 802-11-wireless-security.pairwise ccmp 802-11-wireless-security.group ccmp
    nmcli connection modify Hotspot 802-11-wireless-security.psk "Central1985"
    nmcli connection modify Hotspot ipv4.method shared
fi

nmcli connection up Hotspot >/dev/null 2>&1 || true

echo ""
echo -e "${BOLD}${GREEN}══════════════════════════════════════════════════════════════════${RESET}"
echo -e "${BOLD}${GREEN}       ¡INSTALACIÓN COMPLETADA CON ÉXITO!                        ${RESET}"
echo -e "${BOLD}${GREEN}══════════════════════════════════════════════════════════════════${RESET}"
echo -e "Podés gestionar tu red con el comando:"
echo -e "  ${BOLD}${CYAN}hotspot status${RESET}     -> Ver estado de la red y clientes"
echo -e "  ${BOLD}${CYAN}hotspot qr${RESET}         -> Ver código QR para conectar el teléfono"
echo -e "  ${BOLD}${CYAN}hotspot help${RESET}       -> Ver todos los comandos"
echo ""
