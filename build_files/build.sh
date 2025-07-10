#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

custom_binaries=("steam-session")

ln -s /run /var/run

# this installs a package from fedora 
dnf5 install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf5 config-manager setopt fedora-cisco-openh264.enabled=1
rsync -rvK /ctx/system_files/shared/ /

for f in $custom_binaries; do
    chmod +x /usr/bin/$f
done

dnf5 install -y @development-tools \
    gtk-murrine-engine \
    codium \
    steam \
    godot \
    gamescope \
    tailscale \
    distrobox \
    syncthing \
    just \
    gnome-shell-extension-just-perfection \
    gnome-shell-extension-caffeine

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
