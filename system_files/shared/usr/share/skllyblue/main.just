
install-emubox:
    sh -c "$(curl -sSL https://emubox.pupper.space/install)"

add-syncthing-folder name id path:
    syncthing cli config folders add \
        --label {{ name }} \
        --id {{ id }} \
        --path {{ path }}

update:
    #!/bin/bash
    topgrade --skip-notify
    val=$(notify-send  "Update Complete" ":3" --icon="/var/home/skullbite/.local/share/icons/update.png" --app-name="System Update" --action="reboot=Reboot")
    if [[ $val == "reboot" ]]; then
        systemctl reboot
    fi

    
_first-boot:
    #!/bin/bash
    if [ ! -f ~/.skllyblue-initialized ]; then
        for i in "$(skllyjust _package-list-to-string /usr/share/skllyblue/sys-flatpaks)"; do
            flatpak install -y flathub $i
        done

        touch ~/.skllyblue-initialized
    fi
    
_package-list-to-string +path:
    #!/usr/bin/env python3
    lines = []
    with open("{{ path }}", "r") as f:
        lines = [i.replace("\n", "") for i in f.readlines()]
        
    print(" ".join(lines))
    