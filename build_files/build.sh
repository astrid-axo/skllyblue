#!/bin/bash

set -ouex pipefail

uneeded_apps=("syncthing-start")

rsync -rvK /ctx/system_files/shared/ /
ln -s /run /var/run

rm /usr/share/pixmaps/fedora-gdm-logo.png
cp /usr/share/plymouth/themes/spinner/watermark.png /usr/share/pixmaps/fedora-gdm-logo.png

python3 /ctx/update_os_release.py
echo "skllyblue" >> /etc/hostname

for f in "skllyjust"; do
    chmod +x /usr/bin/$f
done

xdg-icon-resource install --size 256 /usr/share/icons/skllyblue/update.png skllyblue-update

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



cd /tmp
git clone https://github.com/shahnawazshahin/steam-using-gamescope-guide
cd steam-using-gamescope-guide/usr

for f in $(ls ./bin); do
    cp -r ./bin/$f /usr/bin/$f
done

cp ./share/wayland-sessions/steam.desktop /usr/share/wayland-sessions/steam.desktop
cd /tmp
rm -rf ./steam-using-gamescope-guide

dnf5 install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf5 config-manager setopt fedora-cisco-openh264.enabled=1

dnf5 install -y @development-tools \
    qemu \
    libvirt \
    nginx \
    fzf \
    codium \
    steam \
    godot \
    gamescope \
    tailscale \
    distrobox \
    syncthing \
    just \
    fastfetch \
    vim \
    nautilus-python 
    
for f in $uneeded_apps; do
    rm -f /usr/share/applications/$f.desktop
done

dnf5 remove -y firefox \
    toolbox \
    blender \
    gnome-shell-extension-background-logo \
    gnome-shell-extension-window-list \
    gnome-shell-extension-apps-menu \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-places-menu \
    gnome-extensions-app \
    gnome-help-app \
    gnome-tours-app \

gnome_extensions=$(ls /usr/share/gnome-shell/extensions)

# python script packed into a line because uhh
echo -e "[org.gnome.shell]\nenabled-extensions=$(echo "_=\"\"\"$gnome_extensions\"\"\";print('['+', '.join([f\"\"\"'{i}'\"\"\" for i in _.split('\n')])+']')" | python3)" \
    >> /usr/share/glib-2.0/schemas/10_skllyblue.gschema.override

glib-compile-schemas /usr/share/glib-2.0/schemas
dconf update

dnf5 -y copr enable lilay/topgrade
dnf5 -y install topgrade
dnf5 -y copr disable lilay/topgrade

dnf5 -y copr enable vdanielmo/git-credential-manager 
dnf5 -y install git-credential-manager
dnf5 -y copr disable vdanielmo/git-credential-manager

dnf5 -y copr enable umutd3401/extension-manager
dnf5 -y install extension-manager
dnf5 -y copr disable umutd3401/extension-manager 

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable tailscaled
systemctl enable sshd