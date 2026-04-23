!/bin/bash

#────────────────────────────────────────────────────────── Color Section ─────
export TERM=${TERM:-xterm-256color}
GREEN='\033[38;2;143;188;187m'  
RED='\033[38;2;191;97;106m'  
CYAN='\033[38;2;136;192;208m'  
NC='\033[0m'

#───────────────────────────────────────────────────────── Path Variables ─────
REPO_DIR="$HOME/custom-colorscripts"
CONFIG_DEST="$HOME/.config/custom-colorscripts"
LANG_FILE="$CONFIG_DEST/lang"

# Detectar idioma
[ -f "$LANG_FILE" ] && LANGUAGE=$(cat "$LANG_FILE") || LANGUAGE="en"

#─────────────────────────────────────────────────────── Update Process ───────

if [ "$LANGUAGE" = "es" ]; then
    echo -e "󰚰 ${CYAN}Actualizando custom-colorscripts...${NC}"
else
    echo -e "󰚰 ${CYAN}Updating custom-colorscripts...${NC}"
fi

if [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR" || exit 1
    

    if git pull origin main; then
        if [ "$LANGUAGE" = "es" ]; then
            echo -e " ${GREEN}Repositorio actualizado desde GitHub.${NC}"
        else
            echo -e " ${GREEN}Repository updated from GitHub.${NC}"
        fi
    else
        if [ "$LANGUAGE" = "es" ]; then
            echo -e " ${RED}Error al conectar con GitHub. Verifica tu internet.${NC}"
        else
            echo -e " ${RED}Error connecting to GitHub. Check your internet.${NC}"
        fi
        exit 1
    fi
else
    if [ "$LANGUAGE" = "es" ]; then
        echo -e " ${RED}Error: No se encontró el repo en $REPO_DIR${NC}"
    else
        echo -e " ${RED}Error: Repository not found at $REPO_DIR${NC}"
    fi
    exit 1
fi

CONFIG_SOURCE="$REPO_DIR/.config/custom-colorscripts"

if [ -d "$CONFIG_SOURCE" ]; then
    cp -ru "$CONFIG_SOURCE/"* "$CONFIG_DEST/"
    
    if [ "$LANGUAGE" = "es" ]; then
        echo -e " ${GREEN}¡Nuevos ANSIs y diseños instalados correctamente!${NC}"
    else
        echo -e " ${GREEN}New ANSIs and designs installed successfully!${NC}"
    fi
else
    if [ "$LANGUAGE" = "es" ]; then
        echo -e " ${RED}No se encontró la carpeta .config en el repositorio.${NC}"
    else
        echo -e " ${RED}Configuration folder not found in the repository.${NC}"
    fi
fi

#────────────────────────────────────────────────────────── Finalization ─────

if [ "$LANGUAGE" = "es" ]; then
    echo -e "\n${CYAN}Todo listo. ¡Disfruta del nuevo arte!${NC}"
else
    echo -e "\n${CYAN}All set. Enjoy the new art!${NC}"
fi

#I HATE EVERYTING 
