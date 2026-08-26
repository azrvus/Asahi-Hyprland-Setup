#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/YOUR_USERNAME/asahi-hyprland-setup.git"
TEMP_DIR="/tmp/asahi-hyprland-setup"

echo "=========================================="
echo " Starting Asahi Hyprland Automated Setup  "
echo "=========================================="

# 1. Install bare essentials needed on a fresh minimal OS
echo "--> Installing git, curl, and base dependencies..."
sudo dnf check-update || true
sudo dnf install -y git curl wget nano

# 2. Clone JaKooLit's Fedora-Hyprland script
echo "--> Fetching JaKooLit Fedora-Hyprland..."
if [ -d "$HOME/Fedora-Hyprland" ]; then
    rm -rf "$HOME/Fedora-Hyprland"
fi
git clone --depth=1 https://github.com/JaKooLit/Fedora-Hyprland.git "$HOME/Fedora-Hyprland"

# 3. Execute JaKooLit installer non-interactively
echo "--> Running JaKooLit installer..."
cd "$HOME/Fedora-Hyprland"
chmod +x install.sh

# If JaKooLit's script supports automated flags, pass them here.
# Running standard install:
./install.sh

# 4. Clone your overlay repo and copy customized config files
echo "--> Applying your personal dotfiles & fixes..."
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi
git clone --depth=1 "$REPO_URL" "$TEMP_DIR"

if [ -d "$TEMP_DIR/hypr-overlay" ]; then
    cp -rf "$TEMP_DIR/hypr-overlay/"* "$HOME/.config/hypr/"
    echo "--> Custom configs (gestures, scaling, keybind fixes) applied successfully!"
fi

# Clean up temp clone
rm -rf "$TEMP_DIR"

echo "=========================================="
echo " Setup Complete! Reboot your system.      "
echo "=========================================="
