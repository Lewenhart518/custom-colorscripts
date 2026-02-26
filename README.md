🎨 Custom Colorscripts
A collection of custom ANSI pixel art. Give your terminal a unique personality every time you open a new session.

## 📌 Index  

- [Required](#required)  
- [Available Languages](#languages)  
- [Available Themes](#themes)  
- [Installation](#installation)  
- [Configuration](#configuration)  
- [Update](#update)
- [Command list](#command-list)
- [How use the commands](#How-use-the-commands)
- [View Available Cats](#view-available-cats)
- [Custom](#Custom-meows)
- [Features](#features)  
- [Credits](#credits)  
- [Author](#author)


## Required  

• A terminal emulator with 256-color or True Color support.

• **[Nerd Fonts](https://www.nerdfonts.com/)** installed (optional).

# Languages  
The available languages are: 
· English
  and
· Spanish

## Themes  
This project supports several themes and color schemes that enhance your terminal’s aesthetics:

- **Nord Theme**: A clean, elegant arctic color scheme developed by [Sven Greb](https://www.nordtheme.com).  
- **Catppuccin**: A community-driven pastel theme offering variants such as Latte, Frappé, Macchiato, and Mocha.  
- **Everforest**: A soft, low-contrast theme optimized to reduce eye strain.  

Thanks to the creators and communities behind these themes for their amazing work.

## Installation  
To install `meow-colorscripts`, run the following commands in your terminal:  

```bash
git clone https://github.com/Lewenhart518/custom-colorscripts.git
``` 
```bash
cd custom-colorscripts/
``` 
```bash
chmod +x install.sh setup.sh
``` 
```bash
clear && ./install.sh
```  

The installation script will automatically:  
- Set up the required configuration folder.  
- Move the configuration from `~/meow-colorscripts/.config/meow-colorscripts/` to `~/.config/meow-colorscripts/`.  
- Copy necessary files (like `main.sh`).  
- Ask if you want to open the interactive setup immediately.

## Configuration  
Customize your installation using:  

```bash
meow-colorscripts-setup
```  

This command allows you to interactively choose your configuration options:  

- **Select your style** (e.g., *normal*, a theme such as *nord*, *catpuccin*, *everforest*, or special.  
- **Choose the colorscript size** (small, normal, large and automatic).  
- **Activate additional commands**:  
  - `custom-colorscripts-names` displays the list of available cat designs.  
  - `custom-colorscripts-show [style] [size] [name]` displays the ANSI art for the specified cat design.  
- **Enable auto-run**: Decide if you want `custom-colorscripts` to execute automatically when opening a terminal.

During setup, responses are handled interactively:  
- In Spanish, answer with **s** (sí) or **n** (no).  
- In English, answer with **y** (yes) or **n** (no).

## Update  
_To update, follow this simple step:
```bash
- custom-colorscripts-update
``` 

## Command List
The available commands are:

- custom-colorscripts # Displays random ANSI art based on the configuration
- custom-colorscripts-names # Show the name and style of the native ANSI arts
- custom-colorscripts-setup # Start the setup
- custom-colorscripts-show [style] [size] [name] # Displays an specific ANSI art
- custom-colorscripts-update # Update ANSI art

## How use the commands
1. **custom-colorscripts**  
   - Simply run `custom-colorscripts` to display a random ANSI art according to your current configuration.
     
2. **custom-colorscripts-update**  
   - Pulls the latest updates from the repository and refreshes the installed scripts. Use this command regularly to enjoy the latest art and improvements.

3. **custom-colorscripts-setup**  
   - Launches an interactive menu that guides you through configuring your terminal art preferences. You'll be prompted to select a style and decide on extra features, and set up auto-run.

4. **meow-colorscripts-names**
   - Displays a comprehensive list of the available ANSI art's. Use this command to see what art designs are available and choose one for display.

5. **meow-colorscripts-show [style] [size] [name]**  (It only works if you chose it in the setup.)
   - Use this command to display a specific ANSI art. For example:
     
     `meow-colorscripts-show normal normal raspi`
     
     This command searches for the file at `~/.config/custom-colorscripts/colorscripts/normal/normal/raspi.txt`.  
     If the file is missing, an error message will prompt you to check the available names using `custom-colorscripts-names` or visit the repository at [GitHub](https://github.com/Lewenhart518/meow-colorscripts) and will print the Error art.

## Custom ANSI Art
you can make your own ANSI Art if you put your ANSI Art inside the directory ~/.config/custom-colorscripts/colorscripts/[style you chose]/[size]/ or to ~/.config/meow-colorscripts/colorscripts/custom/custom/ and view it with meow-colorscripts-show [name of your carpet] [name of your carpet] [name of your ANSI Art]

## Features  
- High-quality ANSI art  
- Easy and fast installation  
- Works across various terminal setups  
- Fully customizable configuration
- Its very simple
- Smart Resizing

## Credits  
`meow-colorscripts` was born from the inspiration of amazing terminal customization projects. Special thanks to:

- **[Pokémon-Colorscripts](https://gitlab.com/phoneybadger/pokemon-colorscripts)** – For its creative take on terminal colorscripts.

-

Their projects played a fundamental role in inspiring this work.
