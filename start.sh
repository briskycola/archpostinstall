#!/bin/bash
#
#  ____              _   _
# / ___|  __ _ _ __ | |_(_) __ _  __ _  ___
# \___ \ / _` | '_ \| __| |/ _` |/ _` |/ _ \
#  ___) | (_| | | | | |_| | (_| | (_| | (_) |
# |____/ \__,_|_| |_|\__|_|\__,_|\__, |\___/
#                                |___/
#
# Arch Linux post-installation script
# by Santiago Torres

function startPostInstall()
{
    # Start message
    echo ""
    echo "Starting post-installation"
    sleep 2

    # Update Arch mirrors
    echo "Updating Arch mirrors"
    pacman -Syy > /dev/null 2>&1

    # Install GPU drivers
    bash scripts/installGPUDrivers.sh

    # Install essentials for AUR helper
    echo "Installing essentials packages (git base-devel linux-headers)"
    pacman -S --noconfirm base-devel linux-headers git > /dev/null 2>&1

    # Install KDE along with some applications and tools
    bash scripts/installKDE.sh

    # Configure UFW
    echo "Configuring Firewall and enabling services"
    ufw default deny incoming   > /dev/null 2>&1
    ufw default allow outgoing  > /dev/null 2>&1

    # Enable UFW and SDDM on startup
    ufw enable              > /dev/null 2>&1
    systemctl enable ufw    > /dev/null 2>&1
    systemctl enable sddm   > /dev/null 2>&1

    # Sucess message
    echo ""
    echo "$(tput setaf 2)Installation Successful$(tput sgr0)"
    echo "You may now restart your system"
    echo "Type 'sudo reboot' to restart into your new OS"
}

if [ $USER != "root" ]; then
    echo "You must run this script as root"
    echo "type 'sudo ./start.sh'"
    exit 1
fi

echo ""
echo "This is Santiago's Arch Linux post-installation script"
echo "This script installs a minimal version of KDE with only the tools that you need"
echo "This script assumes that you have Arch Linux fully installed"
echo ""

while true; do
    read -p "Do you want to continue? y/n: " USER_CHOICE
    if   [ $USER_CHOICE = 'y' ]; then
        startPostInstall
        break
    elif [ $USER_CHOICE = 'n' ]; then
        echo "Exiting"
        break
    else
        echo "You must select y/n"
        echo ""
    fi
done
