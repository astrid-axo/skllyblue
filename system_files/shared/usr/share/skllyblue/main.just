*-*--
install-emubox:
    sh -c "$(curl -sSL https://emubox.pupper.space/install)"

manage-decky:
    curl -SsL -o /tmp/decky.sh https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/user_install_script.sh
    chmod +x /tmp/decky.sh
    /tmp/decky.sh
    rm /tmp/decky.sh


add-syncthing-folder name id path:
    syncthing cli config folders add \
        --label {{ name }} \
        --id {{ id }} \
        --path {{ path }}
    
_first-boot:
    #!/bin/bash
    if [ ! -f ~/.skllyblue-initialized ]; then
        for i in "$(cat /usr/share/skllyblue/sys-flatpaks)"; do
            flatpak install -y flathub "$i"
        done

        systemctl --user enable --now syncthing
        systemctl --user enable --now bazaar
        

        touch ~/.skllyblue-initialized
    fi

update:
    #!/bin/bash
    topgrade --skip-notify
    val=$(notify-send "Update Complete" ":3" --expire-time=8000 --icon="skllyblue-upate" --app-name="System Update" --action="reboot=Reboot")
    if [[ $val == "reboot" ]]; then
        systemctl reboot
    fi

