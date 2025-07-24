#!/bin/bash

set -ouex pipefail

# i don't think i can remove gnome shell apps, but i'll hide their desktop files anyway
uneeded_apps=("org.gnome.Shell.Extensions org.gnome.Tour syncthing-start")

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

rsync -rvK /ctx/system_files/shared/ /
ln -s /run /var/run

rm /usr/share/pixmaps/fedora-gdm-logo.png
cp /usr/share/plymouth/themes/spinner/watermark.png /usr/share/pixmaps/fedora-gdm-logo.png

python3 /ctx/update_os_release.py

# this installs a package from fedora 
dnf5 install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf5 config-manager setopt fedora-cisco-openh264.enabled=1

for f in "skllyjust"; do
    chmod +x /usr/bin/$f
done

cd /tmp
git clone https://github.com/shahnawazshahin/steam-using-gamescope-guide
cd steam-using-gamescope-guide/usr

for f in $(ls ./bin); do
    cp -r ./bin/$f /usr/bin/$f
done

cp ./share/wayland-sessions/steam.desktop /usr/share/wayland-sessions/steam.desktop
cd /tmp
rm -rf ./steam-using-gamescope-guide

dnf5 install -y gnome-shell-extension-just-perfection 

dnf5 install -y @development-tools \
    qemu \
    libvirt \
    gtk-murrine-engine \
    codium \
    steam \
    godot \
    gamescope \
    tailscale \
    distrobox \
    syncthing \
    just \
    fastfetch \
    gnome-shell-extension-blur-my-shell \
    gnome-shell-extension-just-perfection \
    gnome-shell-extension-caffeine 

for f in $uneeded_apps; do
    rm -f /usr/share/applications/$f.desktop
done

dnf5 remove -y firefox \
    toolbox \
    gnome-shell-extension-background-logo \
    gnome-shell-extension-window-list \
    gnome-shell-extension-apps-menu \
    gnome-shell-extension-launch-new-instance 


# TODO: figure out less static way to get extension links...
curl -o /tmp/arcmenu.zip https://extensions.gnome.org/extension-data/arcmenuarcmenu.com.v64.shell-extension.zip
unzip /tmp/arcmenu.zip -d /usr/share/gnome-shell/extensions/arcmenu@arcmenu.com

dconf update

gsettings set org.gnome.shell.extensions.just-perfection top-panel-position 1

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 -y copr enable lilay/topgrade
dnf5 -y install topgrade
dnf5 -y copr disable lilay/topgrade

dnf5 -y copr enable vdanielmo/git-credential-manager 
dnf5 -y install git-credential-manager
dnf5 -y copr disable vdanielmo/git-credential-manager

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable tailscaled
systemctl enable sshd