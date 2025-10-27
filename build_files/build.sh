#!/bin/bash

set -ouex pipefail

uneeded_apps=("syncthing-start syncthing-ui yelp")



# shell_ver=$(gnome-shell --version)
# shell_ver=($shell_ver)
# shell_ver=${shell_ver[2]}
# 
# for f in $gnome_extensions; do
#     data=$(curl "https://extensions.gnome.org/extension-info/?uuid=$f&shell_version=$shell_ver")
#     download_url=$(echo $data | jq -r '.download_url')
#     ext_dir="/usr/share/gnome-shell/extensions/$f"
# 
#     curl -o /tmp/$f.zip -L "https://extensions.gnome.org$download_url"
#     unzip -d $ext_dir /tmp/$f.zip
#     rm /tmp/$f.zip
# 
#     if [ -d $ext_dir/locale ]; then
#         rsync -rvK $ext_dir/locale /usr/share/locale
#     fi
# 
#     if [ -d $ext_dir/schemas ]; then
#         for f in $(ls $ext_dir/schemas); do
#             if [[ $f == *.xml ]]; then
#                 cp $ext_dir/schemas/$f /usr/share/glib-2.0/schemas
#             fi
#         done
#     fi
# done

for f in $uneeded_apps; do
    rm -f /usr/share/applications/$f.desktop
done



#gnome_extensions=$(ls /usr/share/gnome-shell/extensions)
#python script packed into a line because uhh
#echo -e "[org.gnome.shell]\nenabled-extensions=$(echo "_=\"\"\"$gnome_extensions\"\"\";print('['+', '.join([f\"\"\"'{i}'\"\"\" for i in _.split('\n')])+']')" | python3)" \
#    >> /usr/share/glib-2.0/schemas/40_skllyblue.gschema.override
#cat /usr/share/glib-2.0/schemas/40_skllyblue.gschema.override
#glib-compile-schemas /usr/share/glib-2.0/schemas
dconf update



#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable tailscaled
systemctl enable sshd

# regenerate initramfs - stolen from ublue-os/main
KERNEL_VERSION="$(rpm -q --queryformat="%{evr}.%{arch}" kernel-core)"

# Ensure Initramfs is generated
export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly --kver "${KERNEL_VERSION}" --reproducible -v --add ostree -f "/lib/modules/${KERNEL_VERSION}/initramfs.img"
chmod 0600 "/lib/modules/${KERNEL_VERSION}/initramfs.img"