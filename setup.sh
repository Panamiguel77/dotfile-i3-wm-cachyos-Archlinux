#!/bin/bash
# ============================================================
#   DOTFILES SETUP - pana @ CachyOS
#   Instala paquetes y copia todas las configs automáticamente
# ============================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}"
echo "  ██████╗  █████╗ ███╗   ██╗ █████╗ "
echo "  ██╔══██╗██╔══██╗████╗  ██║██╔══██╗"
echo "  ██████╔╝███████║██╔██╗ ██║███████║"
echo "  ██╔═══╝ ██╔══██║██║╚██╗██║██╔══██║"
echo "  ██║     ██║  ██║██║ ╚████║██║  ██║"
echo "  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝"
echo -e "${NC}"
echo -e "${GREEN}  Dotfiles Setup - pana @ CachyOS${NC}"
echo "  ======================================"
echo ""

# --- INSTALAR PAQUETES ---
echo -e "${YELLOW}[1/4] Instalando paquetes...${NC}"

PACMAN_PKGS=(
    i3
    polybar
    rofi
    kitty
    picom
    xwallpaper
    thunar
    papirus-icon-theme
    python3
)

AUR_PKGS=(
    catppuccin-gtk-theme-mocha
    papirus-folders-git
    pokemon-colorscripts-git
)

echo -e "${BLUE}  → Instalando desde pacman...${NC}"
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

echo -e "${BLUE}  → Instalando desde AUR (yay)...${NC}"
yay -S --needed --noconfirm "${AUR_PKGS[@]}"

echo -e "${GREEN}  ✓ Paquetes instalados${NC}"
echo ""

# --- CREAR CARPETAS ---
echo -e "${YELLOW}[2/4] Creando carpetas de configuración...${NC}"

mkdir -p ~/.config/i3
mkdir -p ~/.config/polybar
mkdir -p ~/.config/rofi
mkdir -p ~/.config/kitty
mkdir -p ~/.config/picom
mkdir -p ~/Wallpapers

echo -e "${GREEN}  ✓ Carpetas creadas${NC}"
echo ""

# --- COPIAR CONFIGS ---
echo -e "${YELLOW}[3/4] Copiando configuraciones...${NC}"

# Obtener directorio donde está el script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# i3
if [ -f "$SCRIPT_DIR/configs/i3-config" ]; then
    cp "$SCRIPT_DIR/configs/i3-config" ~/.config/i3/config
    echo -e "${BLUE}  → i3 config copiada${NC}"
else
    echo -e "${RED}  ✗ No se encontró configs/i3-config${NC}"
fi

# polybar
if [ -f "$SCRIPT_DIR/configs/polybar-config" ]; then
    cp "$SCRIPT_DIR/configs/polybar-config" ~/.config/polybar/config.ini
    echo -e "${BLUE}  → polybar config copiada${NC}"
else
    echo -e "${RED}  ✗ No se encontró configs/polybar-config${NC}"
fi

# rofi
if [ -f "$SCRIPT_DIR/configs/rofi-config.rasi" ]; then
    cp "$SCRIPT_DIR/configs/rofi-config.rasi" ~/.config/rofi/config.rasi
    echo -e "${BLUE}  → rofi config copiada${NC}"
else
    echo -e "${RED}  ✗ No se encontró configs/rofi-config.rasi${NC}"
fi

# kitty
if [ -f "$SCRIPT_DIR/configs/kitty.conf" ]; then
    cp "$SCRIPT_DIR/configs/kitty.conf" ~/.config/kitty/kitty.conf
    echo -e "${BLUE}  → kitty config copiada${NC}"
else
    echo -e "${RED}  ✗ No se encontró configs/kitty.conf${NC}"
fi

# picom
if [ -f "$SCRIPT_DIR/configs/picom.conf" ]; then
    cp "$SCRIPT_DIR/configs/picom.conf" ~/.config/picom/picom.conf
    echo -e "${BLUE}  → picom config copiada${NC}"
else
    echo -e "${RED}  ✗ No se encontró configs/picom.conf${NC}"
fi

echo -e "${GREEN}  ✓ Configs copiadas${NC}"
echo ""

# --- APLICAR TEMAS ---
echo -e "${YELLOW}[4/4] Aplicando temas e iconos...${NC}"

# Tema GTK
xfconf-query -c xsettings -p /Net/ThemeName -s "catppuccin-mocha-blue-standard+default" 2>/dev/null
echo -e "${BLUE}  → Tema GTK aplicado${NC}"

# Iconos Papirus
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark" 2>/dev/null
echo -e "${BLUE}  → Iconos Papirus-Dark aplicados${NC}"

# Color carpetas Papirus (azul)
papirus-folders -C bluegrey --theme Papirus-Dark 2>/dev/null
echo -e "${BLUE}  → Color de carpetas aplicado (bluegrey)${NC}"

# Pokemon en kitty - agregar al final si no está ya
if ! grep -q "pokemon-colorscripts" ~/.config/kitty/kitty.conf; then
    echo "" >> ~/.config/kitty/kitty.conf
    echo "# --- POKEMON RANDOM AL ABRIR TERMINAL ---" >> ~/.config/kitty/kitty.conf
    echo "startup_session none" >> ~/.config/kitty/kitty.conf
    # Agregar al bashrc/zshrc
    SHELL_RC="$HOME/.bashrc"
    [ -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.zshrc"
    if ! grep -q "pokemon-colorscripts" "$SHELL_RC"; then
        echo "" >> "$SHELL_RC"
        echo "# Pokemon random al abrir terminal" >> "$SHELL_RC"
        echo "pokemon-colorscripts --random 2>/dev/null" >> "$SHELL_RC"
        echo -e "${BLUE}  → Pokemon colorscripts agregado a $SHELL_RC${NC}"
    fi
fi

echo ""
echo -e "${GREEN}  ======================================"
echo -e "  ✓ Setup completado exitosamente!"
echo -e "  ======================================"
echo -e "${NC}"
echo -e "  Reinicia i3 con ${YELLOW}Super+Shift+R${NC} para aplicar todo."
echo ""
