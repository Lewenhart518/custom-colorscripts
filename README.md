󰄛 Custom Colorscripts

A collection of custom ANSI pixel art. Give your terminal a unique personality every time you open a new session.

󰏘 Features
• Dynamic Themes: Native support for Nord, Catppuccin, Everforest, and more.

• Smart Resizing: Available in `small`, `normal`, and `big` versions to fit any window size.

• Bilingual Support: Full installer and setup interface in both English and Spanish.

• Modular Design: Standalone commands for displaying, listing, and updating art assets.

• Custom Colorscripts: You can add custom colorscripts if you want.

󰆍 Requirements
• A terminal emulator with 256-color or True Color support.

• Nerd Fonts(https://www.nerdfonts.com/) installed (recommended for UI icons).

󰏗 Installation
Cloning the repository and running the installer is all you need:

```

git clone https://github.com/Lewenhart518/custom-colorscripts

cd custom-colorscripts

chmod +x install.sh setup.sh

./install.sh

```

Note: The installer automatically manages your PATH in `~/.zshrc`, `~/.bashrc`, or `~/.config/fish/config.fish`. Please restart your terminal after the process is finished.

󰒓 Setup
To select settings, like enable terminal startup autorun run:

```

custom-colorscripts-setup

or 

cd custom-colorscripts
./setup

```

󰭟 Available Commands
󰄛 Manual Usage Example
If you want to display a specific cat (e.g., the `raspi` model in `normal` size with the `normal` style):

```

custom-colorscripts-show normal normal raspi

```

󰚚 Credits
(Pokemon-Colorscripts)[https://gitlab.com/phoneybadger/pokemon-colorscripts]
Me! :P

---
