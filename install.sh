#!/bin/bash
# ╔══════════════════════════════════════════════════════════╗
# ║        Arch Pywal Rice — Auto Installer                  ║
# ║  Run once after cloning:  bash install.sh                ║
# ╚══════════════════════════════════════════════════════════╝

set -e

REPO="$(cd "$(dirname "$0")" && pwd)"
G='\033[0;32m'; Y='\033[1;33m'; R='\033[0;31m'; B='\033[1;34m'; N='\033[0m'

echo -e "${B}"
echo "╔══════════════════════════════════════════╗"
echo "║      Arch Pywal Rice Installer           ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${N}"

# ── Check not running as root ───────────────────────────────
if [ "$EUID" -eq 0 ]; then
    echo -e "${R}Don't run this as root!${N}"
    exit 1
fi

# ── 1. Install yay if missing ───────────────────────────────
echo -e "${G}[1/7] Checking AUR helper...${N}"
if ! command -v yay &>/dev/null; then
    echo "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    cd /tmp && git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd "$REPO"
fi
echo "✓ yay ready"

# ── 2. Install packages ─────────────────────────────────────
echo -e "${G}[2/7] Installing packages...${N}"
sudo pacman -S --needed --noconfirm \
    python-pywal \
    feh \
    picom \
    terminator \
    rofi \
    xorg-xrdb \
    flameshot \
    ttf-firacode-nerd

echo "✓ Packages installed"

# ── 3. Create config directories ────────────────────────────
echo -e "${G}[3/7] Creating directories...${N}"
mkdir -p ~/.config/wal/templates
mkdir -p ~/.config/rofi
mkdir -p ~/.config/terminator
mkdir -p ~/.config/i3
mkdir -p ~/.local/bin
echo "✓ Directories ready"

# ── 4. Copy pywal templates ─────────────────────────────────
echo -e "${G}[4/7] Copying pywal templates...${N}"
cp "$REPO/.config/wal/templates/colors-i3"              ~/.config/wal/templates/colors-i3
cp "$REPO/.config/wal/templates/colors-rofi-dark.rasi"  ~/.config/wal/templates/colors-rofi-dark.rasi
cp "$REPO/.config/wal/templates/colors-terminator"      ~/.config/wal/templates/colors-terminator
echo "✓ Templates copied"

# ── 5. Setup rofi config (replace HOME_PATH placeholder) ────
echo -e "${G}[5/7] Setting up rofi...${N}"
sed "s|HOME_PATH|$HOME|g" "$REPO/.config/rofi/config.rasi" > ~/.config/rofi/config.rasi
echo "✓ Rofi configured"

# ── 6. Copy terminator config ───────────────────────────────
echo -e "${G}[6/7] Setting up terminator...${N}"
cp "$REPO/.config/terminator/config" ~/.config/terminator/config
echo "✓ Terminator configured"

# ── 7. Install theme script ─────────────────────────────────
echo -e "${G}[7/7] Installing theme script...${N}"
cp "$REPO/.local/bin/theme" ~/.local/bin/theme
chmod +x ~/.local/bin/theme
echo "✓ theme script installed"

# ── Add ~/.local/bin to PATH ─────────────────────────────────
for RC in ~/.zshrc ~/.bashrc; do
    if [ -f "$RC" ] && ! grep -q '.local/bin' "$RC"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$RC"
        echo "✓ Added ~/.local/bin to PATH in $RC"
    fi
done

# ── Copy .xinitrc ────────────────────────────────────────────
if [ ! -f ~/.xinitrc ]; then
    cp "$REPO/.xinitrc" ~/.xinitrc
    echo "✓ .xinitrc installed"
else
    echo -e "${Y}⚠ ~/.xinitrc already exists — skipped (check manually)${N}"
fi

# ── i3 config ────────────────────────────────────────────────
echo ""
echo -e "${Y}╔════════════════════════════════════════════════════════╗"
echo "║  CHOOSE how to apply the i3 config:                    ║"
echo "╚════════════════════════════════════════════════════════╝${N}"
echo ""
echo "  Option A — Use the full i3 config from this repo:"
echo -e "  ${G}cp $REPO/.config/i3/config ~/.config/i3/config${N}"
echo ""
echo "  Option B — Add these lines manually to your existing i3 config:"
echo -e "  ${G}# At the very TOP of ~/.config/i3/config:"
echo "  include ~/.cache/wal/colors-i3"
echo ""
echo "  # In exec section:"
echo "  exec_always --no-startup-id picom --daemon"
echo "  exec_always --no-startup-id wal -R"
echo ""
echo "  # Change terminal keybind from i3-sensible-terminal to:"
echo -e "  bindsym \$mod+Return exec terminator${N}"
echo ""
echo -e "${R}  ⚠ Remove your existing bar { } block from i3 config!"
echo -e "    The pywal template now handles it.${N}"
echo ""
echo "══════════════════════════════════════════════════════════"
echo ""
echo -e "${G}✅ Installation complete!${N}"
echo ""
echo "  Next steps:"
echo "  1. Apply i3 config (see above)"
echo "  2. Put a wallpaper in ~/Pictures/"
echo "  3. Run:  theme ~/Pictures/your-wallpaper.jpg"
echo "  4. Reload i3: Mod+Shift+R"
echo ""
echo "  To change theme anytime:"
echo "  theme ~/Pictures/any-image.jpg"
