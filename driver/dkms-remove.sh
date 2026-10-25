#!/bin/bash
# Baliza DKMS Module Removal Script

if [[ $EUID -ne 0 ]]; then
  echo "Error: Se requieren privilegios de administrador. Ejecute: sudo ./dkms-remove.sh" >&2
  exit 1
fi

DRV_NAME="baliza-rtl8188eus"
DRV_VERSION="1.2.0"

echo "Removiendo módulo DKMS: ${DRV_NAME}/${DRV_VERSION}..."

dkms remove "${DRV_NAME}/${DRV_VERSION}" --all || true
rm -rf "/usr/src/${DRV_NAME}-${DRV_VERSION}"

echo "✓ Módulo DKMS removido."
