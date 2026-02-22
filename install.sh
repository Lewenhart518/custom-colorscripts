#!/bin/bash

# --- Configuración de Colores Nord ---
export TERM=${TERM:-xterm-256color}
NORD0="\033[38;2;46;52;64m";  NORD4="\033[38;2;216;222;233m"
NORD7="\033[38;2;143;188;187m"; NORD8="\033[38;2;136;192;208m"
NORD9="\033[38;2;129;161;193m"; NORD10="\033[38;2;94;129;172m"

GREEN="$NORD7"; RED="\033[31m"; YELLOW="$NORD9"
CYAN="$NORD8"; MAGENTA="$NORD10"; NC='\033[0m'

# --- Variables de Ruta ---
CONFIG_DIR="$HOME/.config/meow-colorscripts"
BIN_DIR="$HOME/.local/bin"
LOCAL_REPO="$(pwd)" # Asumimos que se ejecuta desde el repo clonado

# --- Funciones de Utilidad ---
print_msg() {
    [ "$LANGUAGE" = "es" ] && printf "%b\n" "$1" || printf "%b\n" "$2"
}

print_step() {
    local msg="$1"
    printf "%b" "${MAGENTA}${msg}${NC}"
    for i in {1..3}; do printf "."; sleep 0.1; done
    printf " ${GREEN}${NC}\n"
}

# --- 1. Selección de Idioma ---
clear
printf "${CYAN}▸ Select your language / Selecciona tu idioma:${NC}\n"
printf "  ${YELLOW}1) Español${NC}\n  ${YELLOW}2) English${NC}\n"
read -p "  Choose [1/2]: " LANG_OPTION
LANGUAGE="en"; [[ "$LANG_OPTION" == "1" ]] && LANGUAGE="es"

mkdir -p "$CONFIG_DIR"
echo "$LANGUAGE" > "$CONFIG_DIR/lang"
print_msg "¡Miaunífico! Idioma establecido." "Meow-tastic! Language set."

# --- 2. Preparación del Entorno ---
print_step "$(print_msg "Creando directorios" "Creating directories")"
mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_DIR/colorscripts"

# --- 3. Instalación del Motor Principal (v2.0 con Search) ---
print_step "$(print_msg "Instalando motor principal" "Installing main engine")"

cat << 'EOF' > "$BIN_DIR/meow-colorscripts"
#!/bin/bash
CONFIG_DIR="$HOME/.config/meow-colorscripts"
ART_DIR="$CONFIG_DIR/colorscripts"

show_help() {
    echo "MEOW-COLORSCRIPTS v2.0"
    echo "Usage: meow-colorscripts [OPTION]"
    echo "  -s, --search [style] [size] [name]  Search for a specific cat"
    echo "  -r, --random                        Show a random cat"
    echo "  -l, --list                          List all available cats"
    exit 0
}

case "$1" in
    -s|--search)
        FILE="$ART_DIR/$2/$3/$4.txt"
        [ -f "$FILE" ] && cat "$FILE" || echo "Error: Cat not found in $2/$3/$4"
        ;;
    -r|--random)
        # Busca cualquier .txt en la estructura de carpetas
        RANDOM_CAT=$(find "$ART_DIR" -name "*.txt" | shuf -n 1)
        [ -f "$RANDOM_CAT" ] && cat "$RANDOM_CAT"
        ;;
    -l|--list)
        echo "Available Cats (Style/Size/Name):"
        find "$ART_DIR" -name "*.txt" | sed "s|$ART_DIR/||" | sed 's|.txt||'
        ;;
    *) show_help ;;
esac
EOF
chmod +x "$BIN_DIR/meow-colorscripts"

# --- 4. Migración de Arte ---
if [ -d "$LOCAL_REPO/colorscripts" ]; then
    cp -r "$LOCAL_REPO/colorscripts/"* "$CONFIG_DIR/colorscripts/"
    print_step "$(print_msg "Arte miauctualizado" "Art miauctualized")"
fi

# --- 5. Configuración del PATH ---
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    SHELL_RC="$HOME/.$(basename $SHELL)rc"
    [ -f "$SHELL_RC" ] && echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
    print_step "PATH actualizado en $SHELL_RC"
fi

# --- 6. Instalación de Scripts Adicionales (Update/Uninstall) ---
for tool in update setup uninstall; do
    if [ -f "$LOCAL_REPO/$tool.sh" ]; then
        install -Dm755 "$LOCAL_REPO/$tool.sh" "$BIN_DIR/meow-colorscripts-$tool"
        print_step "meow-colorscripts-$tool instalado"
    fi
done

# --- 7. Finalización ---
echo -e "\n${CYAN}==========================================${NC}"
print_msg "¡Instalación completada!" "Installation complete!"
print_msg "Prueba: meow-colorscripts --random" "Try: meow-colorscripts --random"
echo -e "${CYAN}==========================================${NC}"

read -p "$(print_msg "¿Configurar ahora? [s/n]: " "Setup now? [y/n]: ")" RUN_CONF
[[ "$RUN_CONF" =~ ^[sSyY]$ ]] && "$BIN_DIR/meow-colorscripts-setup"
