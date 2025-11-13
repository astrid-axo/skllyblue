_load-day-theme:
    gsettings set org.gnome.desktop.interface icon-theme WhiteSur-light
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    gsettings set org.gnome.shell.extensions.arcmenu custom-menu-button-icon skllyblue-logo
    gsettings set org.gnome.shell.extensions.user-theme name catppuccin-light
    gsettings set org.gnome.shell.extensions.aztaskbar indicator-color-focused "rgb(23,146,153)"
    gsettings set org.gnome.shell.extensions.aztaskbar indicator-color-running "rgb(124,127,147)"


_load-night-theme:
    gsettings set org.gnome.desktop.interface icon-theme WhiteSur-dark
    gsettings set org.gnome.shell.extensions.arcmenu custom-menu-button-icon skllyblue-logo-white
    gsettings set org.gnome.shell.extensions.user-theme name catppuccin-dark
    gsettings set org.gnome.shell.extensions.aztaskbar indicator-color-focused "rgb(148,226,213)"
    gsettings set org.gnome.shell.extensions.aztaskbar indicator-color-running "rgb(166,173,200)"
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
