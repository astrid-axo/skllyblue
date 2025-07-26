install-emubox:
    sh -c "$(curl -sSL https://emubox.pupper.space/install)"

add-syncthing-folder name id path:
    syncthing cli config folders add \
        --label {{ name }} \
        --id {{ id }} \
        --path {{ path }}

export-box-app box app:
    distrobox enter {{ box }} -- \
        distrobox-export --app {{ app }} -el "none"

_first-boot:
    #!/bin/bash
    if [ ! -f /etc/skllyblue-initialized ]; then
        curl -o /tmp/arcmenu.zip https://extensions.gnome.org/extension-data/arcmenuarcmenu.com.v64.shell-extension.zip
        gnome-extensions install /tmp/arcmenu.zip

        gsettings set org.gnome.shell.extensions.just-perfection startup-status 1
        gsettings set org.gnome.shell.extensions.just-perfection top-panel-position 1
        gsettings set org.gnome.shell.extensions.just-perfection notification-banner-position 5
        
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

        for i in "$(skllyjust _package-list-to-string /usr/share/skllyblue/sys-flatpaks)"; do
            flatpak install -y flathub $i
        done

        touch /etc/skllyblue-initialized
    fi
    
_package-list-to-string +path:
    #!/usr/bin/env python3
    lines = []
    with open("{{ path }}", "r") as f:
        lines = [i.replace("\n", "") for i in f.readlines()]
        
    print(" ".join(lines))
    