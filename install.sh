#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/applications"

echo "Memasang winprint-connect ke $HOME/.local/bin/..."
cp "$DIR/bin/winprint-connect" "$HOME/.local/bin/winprint-connect"
chmod +x "$HOME/.local/bin/winprint-connect"

echo "Memasang launcher desktop..."
cp "$DIR/winprint-connect.desktop" "$HOME/.local/share/applications/winprint-connect.desktop"
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

echo "Instalasi selesai! Anda dapat menjalankan 'winprint-connect' dari terminal atau menu KDE."
