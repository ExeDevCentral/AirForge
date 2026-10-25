#!/usr/bin/env bash
# ==============================================================================
# rtl8188eu-hotspot-toolkit: Automated System Uninstaller
# Author: Exequiel Echevarria <exemetal@hotmail.com> (ExeDevCentral)
# License: MIT
# ==============================================================================

set -eo pipefail

BOLD="\033[1m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: Este desinstalador requiere privilegios de administrador.${RESET}"
    echo -e "Ejecute: ${BOLD}sudo ./uninstall.sh${RESET}"
    exit 1
fi

echo -e "${YELLOW}${BOLD}Desinstalando rtl8188eu-hotspot-toolkit...${RESET}"

# Detener conexión y servicio
nmcli connection down Hotspot 2>/dev/null || true
systemctl stop hotspot.service 2>/dev/null || true
systemctl disable hotspot.service 2>/dev/null || true
rm -f /etc/systemd/system/hotspot.service
systemctl daemon-reload

# Eliminar binario
rm -f /usr/local/bin/hotspot

# Eliminar configuraciones del kernel
rm -f /etc/modprobe.d/8188eu.conf
rm -f /etc/modprobe.d/blacklist-rtl8xxxu.conf

# Eliminar módulo instalado
KERNEL_VER="$(uname -r)"
rm -f "/lib/modules/$KERNEL_VER/kernel/drivers/net/wireless/8188eu.ko"
depmod -a

echo -e "${GREEN}✓ Desinstalación completada con éxito. El sistema ha sido restaurado.${RESET}"
