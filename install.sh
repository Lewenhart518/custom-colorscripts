#!/bin/bash

#────────────────────────────────────────────────────────── Color Section ─────

export TERM=${TERM:-xterm-256color}

NORD0="\033[38;2;46;52;64m"
NORD1="\033[38;2;59;66;82m"
NORD7="\033[38;2;143;188;187m"
NORD8="\033[38;2;136;192;208m"
NORD9="\033[38;2;129;161;193m"
NORD10="\033[38;2;94;129;172m"

GREEN="$NORD7"
RED="$NORD1"
YELLOW="$NORD9"
CYAN="$NORD8"
MAGENTA="$NORD10"
NC='\033[0m'

#────────────────────────────────────────────────────── Utility Functions ─────

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

#───────────────────────────────────────────────────────── Path Variables ─────

CONFIG_DIR="$HOME/.config/custom-colorscripts"
BIN_DIR="$HOME/.local/bin"
LOCAL_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#────────────────────────────────────────────────────── Language Selector ─────

clear
printf "\n${CYAN}▸   Select your language / Selecciona tu idioma:${NC}\n"
printf "  ${YELLOW}1) Español${NC}\n"
printf "  ${YELLOW}2) English${NC}\n"
printf "${MAGENTA}▸ Choose an option [1/2]: ${NC}"
read LANG_OPTION

LANGUAGE="en"
[ "$LANG_OPTION" == "1" ] && LANGUAGE="es"

mkdir -p "$CONFIG_DIR"
echo "$LANGUAGE" > "$CONFIG_DIR/lang"

print_msg "${GREEN}¡Idioma establecido!${NC}" "${GREEN}Language set!${NC}"

#─────────────────────────────────────────────────────── Repository Check ─────

# Mover la carpeta de de .config a ~/
if [ -d "$LOCAL_REPO/.config/custom-colorscripts" ]; then
    print_dynamic_message "Sincronizando archivos de configuración" "Syncing configuration files"
    # Sincroniza todo (incluyendo la carpeta colorscripts/ y el archivo names.txt)
    cp -rp "$LOCAL_REPO/.config/custom-colorscripts/"* "$CONFIG_DIR/"
else
    print_msg "${RED}✖ Error: No se encontró la carpeta .config en el repositorio.${NC}" \
              "${RED}✖ Error: .config folder not found in repository.${NC}"
fi

find "$LOCAL_REPO" -type f -name "*.sh" -exec chmod +x {} \;

#──────────────────────────────────────────────────────────── PATH Update ─────

mkdir -p "$BIN_DIR"
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  CURRENT_SHELL=$(basename "$SHELL")
  case "$CURRENT_SHELL" in
    bash) echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc" ;;
    zsh)  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" ;;
    fish) fish -c "set -U fish_user_paths $BIN_DIR \$fish_user_paths" ;;
    *)    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile" ;;
  esac
  export PATH="$BIN_DIR:$PATH"
fi

print_dynamic_message "PATH actualizado" "PATH updated"

#──────────────────────────────────────────────────────── Binary Installs ─────

# 1. Main Script (the script thath shows the colorscripts) :)
if [ -f "$CONFIG_DIR/main.sh" ]; then
  install -Dm755 "$CONFIG_DIR/main.sh" "$BIN_DIR/custom-colorscripts"
  print_dynamic_message "Comando principal instalado" "Main command installed"
else
  print_msg "${RED}✖ Error: main.sh no encontrado.${NC}" "${RED}✖ Error: main.sh not found.${NC}"
fi

# 2. Update Script
if [ -f "$LOCAL_REPO/update.sh" ]; then
  install -Dm755 "$LOCAL_REPO/update.sh" "$BIN_DIR/custom-colorscripts-update"
  print_dynamic_message "custom-colorscripts-update instalado" "custom-colorscripts-update installed"
fi

# 3. Setup Script
if [ -f "$LOCAL_REPO/setup.sh" ]; then
  install -Dm755 "$LOCAL_REPO/setup.sh" "$BIN_DIR/custom-colorscripts-setup"
  print_dynamic_message "custom-colorscripts-setup instalado" "custom-colorscripts-setup installed"
fi

# 4. Show Script
if [ -f "$LOCAL_REPO/show.sh" ]; then

  install -Dm755 "$LOCAL_REPO/show.sh" "$BIN_DIR/custom-colorscripts-show"
  print_dynamic_message "custom-colorscripts-show instalado" "custom-colorscripts-show installed"
fi

# 5. Names Script
cat << 'EOF' > "$BIN_DIR/custom-colorscripts-names"
#!/bin/bash
CONFIG_DIR="$HOME/.config/custom-colorscripts"
NAME_FILE="$CONFIG_DIR/names.txt"
if [ -f "$NAME_FILE" ]; then
    cat "$NAME_FILE"
else
    # Respaldo
    ls "$CONFIG_DIR/colorscripts/normal/normal" 2>/dev/null | sed 's/\.txt//'
fi
EOF
chmod +x "$BIN_DIR/custom-colorscripts-names"
print_dynamic_message "custom-colorscripts-names instalado" "custom-colorscripts-names installed"

# 6. Uninstall Script
if [ -f "$LOCAL_REPO/uninstall.sh" ]; then
  install -Dm755 "$LOCAL_REPO/uninstall.sh" "$BIN_DIR/custom-colorscripts-uninstall"
  print_dynamic_message "custom-colorscripts-uninstall instalado" "custom-colorscripts-uninstall installed"
fi

#────────────────────────────────────────────────────────── Finalization ─────

printf "\n"
print_msg "${YELLOW} Reinicia tu terminal para aplicar los cambios de PATH.${NC}" \
          "${YELLOW} Restart your terminal to apply PATH changes.${NC}"

if [ "$LANGUAGE" = "es" ]; then
  printf "${CYAN}▸ ¿Deseas iniciar la configuración ahora? [s/n]: ${NC}"
else
  printf "${CYAN}▸ Do you want to start the setup now? [y/n]: ${NC}"
fi

read RUN_CONFIG
if [[ "$RUN_CONFIG" =~ ^[sSyY]$ ]]; then
  "$BIN_DIR/custom-colorscripts-setup"
fi

printf "\n${MAGENTA}"
print_msg "Instalación completada exitosamente." "Installation completed successfully."
printf "${NC}\n"

#hi
