# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

PS1="\[\e[0;36m\][ \[\e[0;36m\]\w \[\e[0;36m\]]\[\e[0;37m\]$ \[\e[0m\]"
if [ ! -z "${CONTAINER_ID}" ]; then
    PS1="\[\e[0;36m\][ 📦 ] - \[\e[0m\]${PS1}"
fi

fastfetch --logo fedora_silverblue --logo-padding-top 6 --logo-padding-left 2

