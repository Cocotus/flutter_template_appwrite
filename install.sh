#!/usr/bin/env bash
set -euo pipefail

# Installs the Linux release bundle for the current user (no root needed):
# copies the bundle to ~/.local/share, registers a .desktop entry so the app
# shows up in the app menu, and installs its icon into the standard hicolor
# icon theme.
#
# Rename the placeholders below when you fork this template:
#   - app_id:   must match linux/CMakeLists.txt's BINARY_NAME (the compiled
#               executable's filename inside bundle/).
#   - app_name: the human-readable name shown in the app menu.

app_id="flutter_template_appwrite"
app_name="Flutter Appwrite Template"

if [[ ! -d bundle ]]; then
  echo "Error: Run this script from the directory containing the bundle/ folder."
  exit 1
fi

echo "Installing $app_name..."

install_dir="$HOME/.local/share/$app_id"
applications_dir="$HOME/.local/share/applications"
desktop_file="$applications_dir/$app_id.desktop"
icon_dir="$HOME/.local/share/icons/hicolor/512x512/apps"

mkdir -p "$install_dir"
cp -r bundle/. "$install_dir/"
chmod +x "$install_dir/$app_id"

mkdir -p "$applications_dir"

# The bundle carries the app's actual logo at this path -- it is a normal
# Flutter asset (declared in pubspec.yaml as assets/images/logo.png, the same
# source flutter_launcher_icons reads for every other platform's icon), not a
# dedicated launcher-icon file `flutter build linux` produces on its own. Do
# not point this at e.g. `assets/icon.png` or any other path that isn't an
# asset actually declared in pubspec.yaml -- that file will never exist in
# the bundle, and the app menu will show no icon at all.
bundled_icon="$install_dir/data/flutter_assets/assets/images/logo.png"

# Installed into the standard hicolor icon theme too, not just referenced by
# absolute path in the .desktop file below: that is what lets desktop
# environments resolve the icon by name (`Icon=$app_id`) everywhere it is
# shown -- app switcher, dock, notifications -- not only in the app menu
# entry.
if [[ -f "$bundled_icon" ]]; then
  mkdir -p "$icon_dir"
  cp "$bundled_icon" "$icon_dir/$app_id.png"
  if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true
  fi
else
  echo "Warning: $bundled_icon not found -- the app menu entry will have no icon." >&2
fi

cat > "$desktop_file" <<EOF
[Desktop Entry]
Name=$app_name
Exec=$install_dir/$app_id
Icon=$app_id
Type=Application
Categories=Utility;
EOF

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$applications_dir" >/dev/null 2>&1 || true
fi

echo "Done! Launch $app_name from your app menu or run: $install_dir/$app_id"
