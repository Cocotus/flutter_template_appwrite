#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d bundle ]]; then
  echo "Error: Run this script from the directory containing the bundle/ folder."
  exit 1
fi

echo "Installing app..."

install_dir="$HOME/.local/share/app"
applications_dir="$HOME/.local/share/applications"
desktop_file="$applications_dir/app.desktop"

mkdir -p "$install_dir"
cp -r bundle/. "$install_dir/"
chmod +x "$install_dir/app"

mkdir -p "$applications_dir"

cat > "$desktop_file" <<EOF
[Desktop Entry]
Name=app
Exec=$HOME/.local/share/app/app
Icon=$HOME/.local/share/app/data/flutter_assets/assets/images/logo.png
Type=Application
Categories=Network;
EOF

echo "Done! Launch app from your app menu or run: ~/.local/share/app/app"
