#!/bin/bash

#────────────────────────────────────────────────────────── Color Section ─────
export TERM=${TERM:-xterm-256color}
RED="\033[38;2;191;97;106m"
CYAN="\033[38;2;136;192;208m"
YELLOW="\033[38;2;235;203;139m"
NC="\033[0m"

#───────────────────────────────────────────────────────── Path Variables ─────
CONFIG_DIR="$HOME/.config/custom-colorscripts"
LANG_FILE="$CONFIG_DIR/lang"

# Detectar idioma
[ -f "$LANG_FILE" ] && LANGUAGE=$(cat "$LANG_FILE") || LANGUAGE="en"

#────────────────────────────────────────────────────── Utility Functions ─────
print_usage() {
    if [ "$LANGUAGE" = "es" ]; then
        echo -e "${CYAN}Uso del comando 'custom-colorscripts-show':${NC}"
        echo -e "  custom-colorscripts-show [estilo] [tamaño] [nombre]\n"
        echo -e "Ejemplo: ${YELLOW}custom-colorscripts-show normal normal raspi${NC}"
        echo -e "\nPara ver los nombres disponibles usa: ${YELLOW}custom-colorscripts-names${NC}"
    else
        echo -e "${CYAN}Usage of 'custom-colorscripts-show' command:${NC}"
        echo -e "  custom-colorscripts-show [style] [size] [name]\n"
        echo -e "Example: ${YELLOW}custom-colorscripts-show normal normal raspi${NC}"
        echo -e "\nTo see available names use: ${YELLOW}custom-colorscripts-names${NC}"
    fi
}

#────────────────────────────────────────────────────────────── Logic ─────────

# Validar que se pasen los 3 argumentos
if [ "$#" -ne 3 ]; then
    print_usage
    exit 1
fi

STYLE="$1"
SIZE="$2"
NAME="$3"

# Ruta corregida incluyendo la carpeta intermedia 'colorscripts'
ART_FILE="$CONFIG_DIR/colorscripts/$STYLE/$SIZE/$NAME.txt"

if [ -f "$ART_FILE" ]; then
    # LA CLAVE: echo -e interpreta las secuencias de escape ANSI del archivo
    echo -e "$(<"$ART_FILE")"
    echo -e "" # Salto de línea extra
else
    # Error bilingüe
    if [ "$LANGUAGE" = "es" ]; then
        echo -e "${RED}✖ El archivo no existe:${NC} $ART_FILE"
        echo -e "${CYAN}▸ Verifica el estilo, tamaño y nombre.${NC}"
    else
        echo -e "${RED}✖ File does not exist:${NC} $ART_FILE"
        echo -e "${CYAN}▸ Check the style, size and name.${NC}"
    fi
    exit 1
fi
