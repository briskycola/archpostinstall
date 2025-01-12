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

function installGPUDrivers
{
    echo ""
    echo "Please select the GPU driver that you wish to install"
    echo "1. AMDGPU (Southern Islands cards and later)"
    echo "2. ATI (Older AMD GPUs)"
    echo "3. Intel"
    echo "4. nvidia-open (Turing and newer)"
    echo "5. nvidia (Maxwell through Ada Lovelace)"
    echo "6. nouveau (open source NVIDIA drivers (for legacy cards))"
    echo "7. QEMU VirtIO/QXL"

    while true; do
        read -p "Enter your choice: " USER_CHOICE

        if   [ $USER_CHOICE = '1' ]; then
            echo "Installing AMDGPU drivers"
            pacman -S --noconfirm xf86-video-amdgpu mesa vulkan-radeon
            break
        elif [ $USER_CHOICE = '2' ]; then
            echo "Installing ATI drivers"
            pacman -S --noconfirm xf86-video-ati mesa
            break
        elif [ $USER_CHOICE = '3' ]; then
            echo "Installing Intel drivers"
            pacman -S --noconfirm xf86-video-intel mesa vulkan-intel
            break
        elif [ $USER_CHOICE = '4' ]; then
            echo "Installing NVIDIA (open) drivers"
            pacman -S --noconfirm nvidia-open nvidia-utils nvidia-settings
            break
        elif [ $USER_CHOICE = '5' ]; then
            echo "Installing NVIDIA drivers"
            pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
            break
        elif [ $USER_CHOICE = '6' ]; then
            echo "Installing Nouveau drivers"
            pacman -S --noconfirm xf86-video-nouveau mesa vulkan-nouveau
            break
        elif [ $USER_CHOICE = '7' ]; then
            echo "Installing QEMU VirtIO/QXL drivers"
            pacman -S --noconfirm xf86-video-qxl qemu-hw-display-qxl \
            qemu-hw-display-virtio-gpu vulkan-virtio
            break
        else
            echo "You must select 1-7"
            echo ""
        fi
    done
}

function installBluetooth()
{
    # Check if the computer has PCIe bluetooth devices
    echo "Checking for PCIe Bluetooth Devices"
    lspci | grep -i bluetooth > /dev/null
    if [ $? -eq 0 ]; then
        echo "Found PCIe Bluetooth"
        echo "Installing Bluetooth utilities"
        pacman -S bluez bluez-utils bluedevil
    else
        echo "No PCIe Bluetooth devices were found"
    fi

    # Check if the computer has USB bluetooth devices
    echo "Checking for USB Bluetooth Devices"
    lsusb | grep -i bluetooth > /dev/null
    if [ $? -eq 0 ]; then
        echo "Found USB Bluetooth"
        echo "Installing Bluetooth utilities"
        pacman -S bluez bluez-utils bluedevil
    else
        echo "No USB Bluetooth devices were found"
    fi
}

function installKDE()
{
    # Install PipeWire
    echo "Installing PipeWire audio server"
    pacman -S --noconfirm pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber

    # Install KDE along with some applications and tools
    echo "Installing KDE along with some applications and tools"
    pacman -S --noconfirm plasma-desktop dolphin dolphin-plugins ffmpegthumbs ark konsole okular gwenview \
    kscreen firefox mpv yt-dlp ffmpeg zed kde-gtk-config breeze-gtk plasma-pa plasma-nm power-profiles-daemon  \
    usbutils partitionmanager ufw sddm sddm-kcm

    # Install Bluetooth utilities if Bluetooth is supported
    installBluetooth
}

function startPostInstall()
{
    # Start message
    echo "Starting post-installation"
    sleep 2

    # Install GPU drivers
    installGPUDrivers

    # Install essentials for AUR helper
    echo "Installing essentials packages (git base-devel linux-headers)"
    pacman -S --noconfirm base-devel linux-headers git

    # Install KDE along with some applications and tools
    installKDE

    # Configure UFW
    echo "Configuring Firewall and enabling services"
    ufw default deny incoming
    ufw default allow outgoing

    # Enable UFW and SDDM on startup
    ufw enable
    systemctl enable ufw
    systemctl enable sddm

    # Sucess message
    echo ""
    echo "Installation Successful"
    echo "You may now restart your system"
    echo "Type 'sudo reboot' to restart into your new OS"
}

if [ $USER != "root" ]; then
    echo "You must run this script as root"
    echo "type 'sudo bash start.sh'"
    exit 1
fi

echo ""
echo "This is Santiago's Arch Linux post-installation script"
echo "This script installs a minimal version of KDE with only the tools that you need"
echo "This script assumes that you have Arch Linux fully installed"

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
