#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

ln -s /run /var/run

# this installs a package from fedora repos
dnf5 install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf5 config-manager setopt fedora-cisco-openh264.enabled=1
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | sudo tee -a /etc/yum.repos.d/vscodium.repo

dnf5 install -y @development-tools \
    gtk-murrine-engine \
    codium \
    steam \
    godot \
    tailscale \
    distrobox \
    syncthing

mkdir -p /usr/share/gnome-shell/extensions
curl -o arcmenu.zip https://extensions.gnome.org/extension-data/arcmenuarcmenu.com.v64.shell-extension.zip
unzip arcmenu.zip -d /usr/share/gnome-shell/extensions/arcmenu@arcmenu.com
rm arcmenu.zip

# flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak install -y flathub app.zen_browser.zen
# flatpak install -y flathub com.usebottles.bottles


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable tailscaled
systemctl enable sshd
