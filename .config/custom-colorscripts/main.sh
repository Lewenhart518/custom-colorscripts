#!/bin/bash

#───────────────────────────────────────────────────────── Path Variables ─────
CONFIG_DIR="$HOME/.config/custom-colorscripts"
# Ruta base donde vive el arte ahora
ART_BASE="$CONFIG_DIR/colorscripts"
CONFIG_FILE="$CONFIG_DIR/config.conf"
LANG_FILE="$CONFIG_DIR/lang"
ERROR_FILE="$ART_BASE/error.txt"

# Colores para mensajes de sistema
RED="\033[38;2;191;97;106m"
CYAN="\033[38;2;136;192;208m"
NC="\033[0m"

#─────────────────────────────────────────────────────── Utility Functions ─────
show_art() {
    local file="$1"
    if [ -f "$file" ]; then
        echo -e "$(<"$file")"
    else
        # Si ni siquiera el error.txt existe, un mensaje final de auxilio
        echo -e "${RED}✖ Error: Critical failure. Art not found.${NC}"
    fi
}

#─────────────────────────────────────────────────────── Language Setup ───────
[ -f "$LANG_FILE" ] && LANGUAGE=$(cat "$LANG_FILE") || LANGUAGE="en"

print_msg() {
    if [ "$LANGUAGE" = "es" ]; then echo -e "$1"; else echo -e "$2"; fi
}

#─────────────────────────────────────────────────────── Load Configuration ───
if [ ! -f "$CONFIG_FILE" ]; then
    if [ "$LANGUAGE" = "es" ]; then
        echo -e "${RED}✖ No se encontró el archivo de configuración.${NC}"
        echo -e "${CYAN}▸ Por favor, ejecuta 'custom-colorscripts-setup' primero.${NC}"
    else
        echo -e "${RED}✖ Configuration file not found.${NC}"
        echo -e "${CYAN}▸ Please run 'custom-colorscripts-setup' first.${NC}"
    fi
    exit 1
fi

source "$CONFIG_FILE"
MEOW_THEME="$CUSTOM_THEME"
MEOW_SIZE="$CUSTOM_SIZE"

#─────────────────────────────────────────────────────── Size Detection ───────
if [ "$MEOW_SIZE" = "auto" ]; then
    TERMWIDTH=$(tput cols)
    if [ "$TERMWIDTH" -lt 80 ]; then REAL_SIZE="small";
    elif [ "$TERMWIDTH" -lt 120 ]; then REAL_SIZE="normal";
    else REAL_SIZE="big"; fi
else
    REAL_SIZE="$MEOW_SIZE"
fi

#────────────────────────────────────────────────────────── Path Logic ────────
# Ajustado a: ~/.config/custom-colorscripts/colorscripts/TEMA/TAMAÑO
ART_DIR="$ART_BASE/$MEOW_THEME/$REAL_SIZE"

# Soporte para tema aleatorio
if [ "$MEOW_THEME" = "random" ]; then
    # Listar carpetas dentro de colorscripts, ignorando archivos
    THEMES=($(ls -d "$ART_BASE"/*/ 2>/dev/null | xargs -n 1 basename 2>/dev/null))
    if [ ${#THEMES[@]} -gt 0 ]; then
        RANDOM_THEME=${THEMES[$RANDOM % ${#THEMES[@]}]}
        ART_DIR="$ART_BASE/$RANDOM_THEME/$REAL_SIZE"
    fi
fi

#───────────────────────────────────────────────────────── Display Logic ──────

# 1. Si se pide un arte específico por nombre: custom-colorscripts [nombre]
if [ -n "$1" ]; then
    SPECIFIC_FILE="$ART_DIR/$1.txt"
    if [ -f "$SPECIFIC_FILE" ]; then
        show_art "$SPECIFIC_FILE"
    else
        show_art "$ERROR_FILE"
        print_msg "${RED}✖ No se encontró el arte: $1${NC}" "${RED}✖ Art not found: $1${NC}"
    fi
# 2. Selección aleatoria (comportamiento normal al abrir terminal)
else
    if [ -d "$ART_DIR" ]; then
        FILES=("$ART_DIR"/*.txt)
        # Verificar si hay archivos .txt en la carpeta
        if [ -e "${FILES[0]}" ]; then
            RANDOM_FILE=${FILES[RANDOM % ${#FILES[@]}]}
            show_art "$RANDOM_FILE"
        else
            show_art "$ERROR_FILE"
            print_msg "${RED}✖ Carpeta vacía: $ART_DIR${NC}" "${RED}✖ Empty folder: $ART_DIR${NC}"
        fi
    else
        show_art "$ERROR_FILE"
        print_msg "${RED}✖ No existe la carpeta: $ART_DIR${NC}" "${RED}✖ Folder missing: $ART_DIR${NC}"
    fi
fi
