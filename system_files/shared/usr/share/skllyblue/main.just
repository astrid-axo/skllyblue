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
        echo "TODO"
        touch /etc/skllyblue-initialized
    done
    