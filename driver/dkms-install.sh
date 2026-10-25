#!/bin/bash
# Baliza DKMS Automated Module Registrar

set -eo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Error: Se requieren privilegios de administrador. Ejecute: sudo ./dkms-install.sh" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRV_NAME="baliza-rtl8188eus"
MOD_NAME="8188eu"
DRV_VERSION="1.2.0"
SRC_DEST="/usr/src/${DRV_NAME}-${DRV_VERSION}"

echo "Registrando módulo en DKMS: ${DRV_NAME}/${DRV_VERSION}..."

mkdir -p "$SRC_DEST"
cp -r "$SCRIPT_DIR"/* "$SRC_DEST/"

# Si ya estaba registrado, removerlo previamente
if dkms status -m "$DRV_NAME" -v "$DRV_VERSION" &>/dev/null; then
    dkms remove -m "$DRV_NAME" -v "$DRV_VERSION" --all || true
fi

dkms add -m "$DRV_NAME" -v "$DRV_VERSION"
dkms build -m "$DRV_NAME" -v "$DRV_VERSION"
dkms install -m "$DRV_NAME" -v "$DRV_VERSION"

echo "✓ Módulo DKMS ${DRV_NAME}/${DRV_VERSION} instalado con éxito. Se reconstruirá automáticamente en cada actualización de kernel."
