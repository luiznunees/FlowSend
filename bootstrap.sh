#!/bin/bash
# FlowSend Bootstrap (Linux/Mac)
# Um comando. Instala FlowSend globalmente. Pronto pra usar.
# Uso: bash <(curl -s https://raw.githubusercontent.com/luiznunees/FlowSend/main/bootstrap.sh)

set -e

REPO="https://github.com/luiznunees/FlowSend.git"
TMP_DIR="/tmp/flowsend-bootstrap"

echo "=== FlowSend Bootstrap ==="
echo "Baixando FlowSend..."

rm -rf "$TMP_DIR"
git clone --depth 1 "$REPO" "$TMP_DIR"

cd "$TMP_DIR"
bash install-global.sh

cd "$HOME"
rm -rf "$TMP_DIR"

echo ""
echo "FlowSend pronto!"
echo ""
echo "Agora abra o OpenCode em QUALQUER pasta e diga:"
echo "  /instalar"
echo "  - ou -"
echo "  'quero configurar o FlowSend'"
