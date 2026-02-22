#!/bin/bash

# --- Colores Nord ---
export TERM=${TERM:-xterm-256color}
GREEN="\033[38;2;143;188;187m"
RED="\033[38;2;191;97;106m" # Rojo Nord más auténtico
YELLOW="\033[38;2;235;203;139m" # Amarillo Nord
CYAN="\033[38;2;136;192;208m"
MAGENTA="\033[38;2;180;142;173m"
BLUE="\033[38;2;129;161;193m"
NC="\033[0m"

# --- Rutas ---
CONFIG_DIR="$HOME/.config/meow-colorscripts"
MEOW_CONF="$CONFIG_DIR/meow.conf"
BIN_DIR="$HOME/.local/bin"
LOCAL_REPO="$(pwd)"

mkdir -p "$CONFIG_DIR" "$BIN_DIR"

# --- Idioma ---
LANGUAGE=$(cat "$CONFIG_DIR/lang" 2>/dev/null || echo "en")

print_msg() {
    [ "$LANGUAGE" = "es" ] && printf "%b\n" "$1" || printf "%b\n" "$2"
}

# --- 1. Selección de Estilo y Tamaño ---
clear
print_msg "${CYAN}▸ Elige tu estilo de meow-colorscripts:${NC}" \
          "${CYAN}▸ Choose your meow-colorscripts style:${NC}"

options=("normal" "memes" "themes (Nord, Catppuccin...)" "small" "normal size")
for i in "${!options[@]}"; do
    printf "  ${YELLOW}$((i+1))) ${options[$i]}${NC}\n"
done

read -p "  $(print_msg "Selecciona [1-5]: " "Select [1-5]: ")" OPT

case $OPT in
    1) MEOW_THEME="normal"; MEOW_SIZE="normal" ;;
    2) MEOW_THEME="memes";  MEOW_SIZE="normal" ;;
    3) 
       print_msg "\n${CYAN}▸ Temas disponibles:${NC}" "${CYAN}▸ Available themes:${NC}"
       printf "  ${YELLOW}1) nord\n  2) catppuccin\n  3) everforest${NC}\n"
       read -p "  [1-3]: " T_OPT
       case $T_OPT in
           1) MEOW_THEME="nord" ;;
           2) MEOW_THEME="catppuccin" ;;
           3) MEOW_THEME="everforest" ;;
       esac
       MEOW_SIZE="normal"
       ;;
    4) MEOW_THEME="normal"; MEOW_SIZE="small" ;;
    5) MEOW_THEME="normal"; MEOW_SIZE="normal" ;;
    *) MEOW_THEME="normal"; MEOW_SIZE="normal" ;;
esac

# --- 2. Guardar Configuración Base ---
{
    echo "export MEOW_THEME=\"$MEOW_THEME\""
    echo "export MEOW_SIZE=\"$MEOW_SIZE\""
} > "$MEOW_CONF"

print_msg "\n${GREEN}✓ Estilo: $MEOW_THEME | Tamaño: $MEOW_SIZE${NC}" \
          "\n${GREEN}✓ Style: $MEOW_THEME | Size: $MEOW_SIZE${NC}"

# --- 3. Activación de Comandos Extra (names / show) ---
print_msg "\n${CYAN}▸ ¿Activar comandos extra (names/show)? [s/n]:${NC}" \
          "\n${CYAN}▸ Activate extra commands (names/show)? [y/n]:${NC}"
read -p "  > " EXTRA_OPT

if [[ "$EXTRA_OPT" =~ ^[sSyY]$ ]]; then
    # meow-colorscripts-names
    echo -e "#!/bin/bash\nls $CONFIG_DIR/colorscripts/$MEOW_THEME/$MEOW_SIZE | sed 's/.txt//'" > "$BIN_DIR/meow-colorscripts-names"
    chmod +x "$BIN_DIR/meow-colorscripts-names"
    
    # meow-colorscripts-show
    if [ -f "$LOCAL_REPO/meow-colorscripts-show.sh" ]; then
        install -Dm755 "$LOCAL_REPO/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
        print_msg "${GREEN}✓ Comandos instalados.${NC}" "${GREEN}✓ Commands installed.${NC}"
    fi
fi

# --- 4. Autorun (Mejorado para no duplicar) ---
print_msg "\n${CYAN}▸ ¿Activar autorun al abrir terminal? [s/n]:${NC}" \
          "\n${CYAN}▸ Enable autorun on startup? [y/n]:${NC}"
read -p "  > " AUTO_OPT

if [[ "$AUTO_OPT" =~ ^[sSyY]$ ]]; then
    SHELL_RC="$HOME/.$(basename $SHELL)rc"
    if [ -f "$SHELL_RC" ]; then
        grep -q "meow-colorscripts" "$SHELL_RC" || echo -e "\n# Meow Colorscripts Autorun\nmeow-colorscripts --random" >> "$SHELL_RC"
        print_msg "${GREEN}✓ Autorun añadido a $SHELL_RC${NC}" "${GREEN}✓ Autorun added to $SHELL_RC${NC}"
    fi
    echo "export MEOW_AUTORUN=\"true\"" >> "$MEOW_CONF"
else
    echo "export MEOW_AUTORUN=\"false\"" >> "$MEOW_CONF"
fi

# --- 5. Meow-Fact (Opcional) ---
print_msg "\n${CYAN}▸ ¿Instalar meow-fact? [s/n]:${NC}" \
          "\n${CYAN}▸ Install meow-fact? [y/n]:${NC}"
read -p "  > " FACT_OPT

if [[ "$FACT_OPT" =~ ^[sSyY]$ ]]; then
    FACT_SRC="$LOCAL_REPO/meow-fact.sh"
    [ -f "$FACT_SRC" ] && install -Dm755 "$FACT_SRC" "$BIN_DIR/meow-fact" && print_msg "${GREEN}✓ meow-fact listo.${NC}" "${GREEN}✓ meow-fact ready.${NC}"
fi

# --- Finalización ---
print_msg "\n${MAGENTA}¡Miau! Configuración guardada en $MEOW_CONF${NC}" \
          "\n${MAGENTA}Meow! Configuration saved to $MEOW_CONF${NC}"
