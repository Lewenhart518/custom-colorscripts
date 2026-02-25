#!/bin/bash

#────────────────────────────────────────────────────────── Color Section ─────
export TERM=${TERM:-xterm-256color}

NORD0="\033[38;2;46;52;64m"
NORD1="\033[38;2;59;66;82m"
NORD4="\033[38;2;216;222;233m"
NORD7="\033[38;2;143;188;187m"
NORD8="\033[38;2;136;192;208m"
NORD9="\033[38;2;129;161;193m"
NORD10="\033[38;2;94;129;172m"

GREEN="$NORD7"
RED="$NORD1"
YELLOW="$NORD9"
CYAN="$NORD8"
MAGENTA="$NORD10"
NC="\033[0m"

#───────────────────────────────────────────────────────── Path Variables ─────
CONFIG_DIR="$HOME/.config/custom-colorscripts"
LANG_FILE="$CONFIG_DIR/lang"
CONFIG_FILE="$CONFIG_DIR/config.conf"
BIN_DIR="$HOME/.local/bin"
LOCAL_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#────────────────────────────────────────────────────── Utility Functions ─────
mkdir -p "$CONFIG_DIR"

if [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
else
    LANGUAGE="en"
fi

print_msg() {
    if [ "$LANGUAGE" = "es" ]; then
        printf -- "%b\n" "$1"
    else
        printf -- "%b\n" "$2"
    fi
}

print_dynamic_message() {
    local msg_es="$1"
    local msg_en="$2"
    local message
    [ "$LANGUAGE" = "es" ] && message="$msg_es" || message="$msg_en"
    
    local delay=0.1
    printf "%b" "${MAGENTA}${message}${NC}"
    for i in {1..3}; do
        printf "."
        sleep $delay
    done
    printf " %b\n" "${GREEN}${NC}"
}

#─────────────────────────────────────────────────────── Style Selection ─────
clear
while true; do
    printf "${CYAN}▸ ${NC}"
    print_msg "Elige tu estilo de colorscripts:" "Choose your colorscripts style:"
    
    if [ "$LANGUAGE" = "es" ]; then
        printf "  ${YELLOW}1) normal${NC}\n"
        printf "  ${YELLOW}2) temas (Nord, Catppuccin, Everforest)${NC}\n"
        printf "  ${YELLOW}3) aleatorio${NC}\n"
        printf "  ${YELLOW}4) especial${NC}\n"
        printf "${MAGENTA}▸ Selecciona una opción [1-4]: ${NC}"
    else
        printf "  ${YELLOW}1) normal${NC}\n"
        printf "  ${YELLOW}2) themes (Nord, Catppuccin, Everforest)${NC}\n"
        printf "  ${YELLOW}3) random${NC}\n"
        printf "  ${YELLOW}4) special${NC}\n"
        printf "${MAGENTA}▸ Select an option [1-4]: ${NC}"
    fi
    read STYLE_OPTION

    case "$STYLE_OPTION" in
        1) CUSTOM_STYLE="normal"; break ;;
        2) CUSTOM_STYLE="themes"; break ;;
        3) CUSTOM_STYLE="random"; break ;;
        4) CUSTOM_STYLE="special"; break ;;
        *) print_msg "${RED}Opción inválida.${NC}" "${RED}Invalid option.${NC}"; sleep 1; clear ;;
    esac
done

#─────────────────────────────────────────────────────── Theme Selection ─────
if [ "$CUSTOM_STYLE" = "themes" ]; then
    clear
    while true; do
        printf "${CYAN}▸ ${NC}"
        print_msg " 󰏘 ¿Qué tema deseas usar?" "Which theme do you want?"
        printf "  ${YELLOW}1) nord${NC}\n"
        printf "  ${YELLOW}2) catppuccin${NC}\n"
        printf "  ${YELLOW}3) everforest${NC}\n"
        printf "  ${RED}q) "
        print_msg "Regresar" "Return"
        printf "${NC}\n"
        printf "${MAGENTA}▸ ${NC}"
        print_msg "Selecciona una opción [1-3/q]: " "Select an option [1-3/q]: "
        read THEME_OPTION

        case "$THEME_OPTION" in
            1) CUSTOM_THEME="nord"; break ;;
            2) CUSTOM_THEME="catppuccin"; break ;;
            3) CUSTOM_THEME="everforest"; break ;;
            q) exec "$0"; exit ;;
            *) print_msg "${RED}Opción inválida.${NC}" "${RED}Invalid option.${NC}"; sleep 1; clear ;;
        esac
    done
else
    CUSTOM_THEME="$CUSTOM_STYLE"
fi

#──────────────────────────────────────────────────────── Size Selection ─────
clear
while true; do
    printf "${CYAN}▸ ${NC}"
    print_msg "Elige el tamaño de los colorscripts:" "Choose your colorscripts size:"
    
    if [ "$LANGUAGE" = "es" ]; then
        printf "  ${YELLOW}1) pequeño${NC}\n"
        printf "  ${YELLOW}2) normal${NC}\n"
        printf "  ${YELLOW}3) grande${NC}\n"
        printf "  ${YELLOW}4) automático (según la terminal)${NC}\n"
        printf "${MAGENTA}▸ Selecciona una opción [1-4]: ${NC}"
    else
        printf "  ${YELLOW}1) small${NC}\n"
        printf "  ${YELLOW}2) normal${NC}\n"
        printf "  ${YELLOW}3) big${NC}\n"
        printf "  ${YELLOW}4) auto (based on terminal size)${NC}\n"
        printf "${MAGENTA}▸ Select an option [1-4]: ${NC}"
    fi
    read SIZE_OPTION

    case "$SIZE_OPTION" in
        1) CUSTOM_SIZE="small"; break ;;
        2) CUSTOM_SIZE="normal"; break ;;
        3) CUSTOM_SIZE="big"; break ;;
        4) CUSTOM_SIZE="auto"; break ;;
        *) print_msg "${RED}Opción inválida.${NC}" "${RED}Invalid option.${NC}"; sleep 1; clear ;;
    esac
done

#────────────────────────────────────────────────────────── Save Config ──────
printf "\n───────────────────────────────────────────────────────\n"
print_msg "Seleccionado: ${GREEN}$CUSTOM_THEME${NC} | Tamaño: ${GREEN}$CUSTOM_SIZE${NC}" \
          "Selected: ${GREEN}$CUSTOM_THEME${NC} | Size: ${GREEN}$CUSTOM_SIZE${NC}"
printf "───────────────────────────────────────────────────────\n"

{
    echo "export CUSTOM_THEME=\"$CUSTOM_THEME\""
    echo "export CUSTOM_SIZE=\"$CUSTOM_SIZE\""
} > "$CONFIG_FILE"

print_dynamic_message "Configuración guardada" "Configuration saved"

#────────────────────────────────────────────────────────────── Autorun ──────
printf "\n${CYAN}▸ "
print_msg "¿Activar autorun al iniciar la terminal?" "Enable autorun on terminal startup?"
if [ "$LANGUAGE" = "es" ]; then
    printf "  ${YELLOW}s) Sí${NC}\n"
    printf "  ${YELLOW}n) No${NC}\n"
    printf "${MAGENTA}▸ [s/n]: ${NC}"
else
    printf "  ${YELLOW}y) Yes${NC}\n"
    printf "  ${YELLOW}n) No${NC}\n"
    printf "${MAGENTA}▸ [y/n]: ${NC}"
fi
read AUTO_OPT

if [[ "$AUTO_OPT" =~ ^[sSyY]$ ]]; then
    CURRENT_SHELL=$(basename "$SHELL")
    case "$CURRENT_SHELL" in
        zsh) RC_FILE="$HOME/.zshrc" ;;
        bash) RC_FILE="$HOME/.bashrc" ;;
        fish) RC_FILE="$HOME/.config/fish/config.fish" ;;
        *) RC_FILE="$HOME/.profile" ;;
    esac

    LINE="custom-colorscripts"
    if [ -f "$RC_FILE" ]; then
        if ! grep -q "custom-colorscripts" "$RC_FILE"; then
            echo -e "\n# Custom Colorscripts Autorun\n$LINE" >> "$RC_FILE"
        fi
    else
        echo -e "# Custom Colorscripts Autorun\n$LINE" > "$RC_FILE"
    fi
    print_dynamic_message "Autorun habilitado" "Autorun enabled"
fi

#────────────────────────────────────────────────────────── Finalization ─────
printf "\n───────────────────────────────────────────────────────\n"
print_msg "          ${MAGENTA}¿Cómo usar los comandos?${NC}" "          ${MAGENTA}How to use the commands?${NC}"
printf "───────────────────────────────────────────────────────\n"

if [ "$LANGUAGE" = "es" ]; then
    echo -e "${CYAN}󰬴 custom-colorscripts-names${NC}"
    echo -e "   Lista todos los nombres de arte disponibles."
    echo -e "${CYAN} custom-colorscripts-show [tema] [tamaño] [nombre]${NC}"
    echo -e "   Muestra un arte específico. Ej: show normal normal raspi"
    echo -e "${CYAN} custom-colorscripts-update${NC}"
    echo -e "   Descarga nuevos ANSIs desde el repositorio."
else
    echo -e "${CYAN}󰬴 custom-colorscripts-names${NC}"
    echo -e "   Lists all available art names."
    echo -e "${CYAN} custom-colorscripts-show [theme] [size] [name]${NC}"
    echo -e "   Shows a specific art. Ex: show normal normal raspi"
    echo -e "${CYAN} custom-colorscripts-update${NC}"
    echo -e "   Downloads new ANSIs from the repository."
fi

printf "\n${YELLOW}󰜉 ${NC}"
print_msg "Reinicia tu terminal o escribe 'source ~/.zshrc' (o tu shell config)." \
          "Restart your terminal or type 'source ~/.zshrc' (or your shell config)."

printf "\n${GREEN} "
print_msg "¡listo! Disfruta." "All done! Enjoy."
printf "${NC}\n"
