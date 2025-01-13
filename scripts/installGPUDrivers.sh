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

echo ""
echo "Please select the GPU driver that you wish to install"
echo "1. AMDGPU (Southern Islands cards and later)"
echo "2. ATI (Older AMD GPUs)"
echo "3. Intel"
echo "4. nvidia-open (Turing and newer)"
echo "5. nvidia (Maxwell through Ada Lovelace)"
echo "6. nouveau (open source NVIDIA drivers (for legacy cards))"
echo "7. QEMU VirtIO/QXL"
echo ""

while true; do
    read -p "Enter your choice: " USER_CHOICE

    if   [ $USER_CHOICE = '1' ]; then
        echo "Installing AMDGPU drivers"
        pacman -S --noconfirm xf86-video-amdgpu mesa vulkan-radeon      > /dev/null 2>&1
        break
    elif [ $USER_CHOICE = '2' ]; then
        echo "Installing ATI drivers"
        pacman -S --noconfirm xf86-video-ati mesa                       > /dev/null 2>&1
        break
    elif [ $USER_CHOICE = '3' ]; then
        echo "Installing Intel drivers"
        pacman -S --noconfirm xf86-video-intel mesa vulkan-intel        > /dev/null 2>&1
        break
    elif [ $USER_CHOICE = '4' ]; then
        echo "Installing NVIDIA (open) drivers"
        pacman -S --noconfirm nvidia-open nvidia-utils nvidia-settings  > /dev/null 2>&1
        break
    elif [ $USER_CHOICE = '5' ]; then
        echo "Installing NVIDIA drivers"
        pacman -S --noconfirm nvidia nvidia-utils nvidia-settings       > /dev/null 2>&1
        break
    elif [ $USER_CHOICE = '6' ]; then
        echo "Installing Nouveau drivers"
        pacman -S --noconfirm xf86-video-nouveau mesa vulkan-nouveau    > /dev/null 2>&1
        break
    elif [ $USER_CHOICE = '7' ]; then
        echo "Installing QEMU VirtIO/QXL drivers"
        pacman -S --noconfirm xf86-video-qxl qemu-hw-display-qxl \
        qemu-hw-display-virtio-gpu vulkan-virtio                        > /dev/null 2>&1
        break
    else
        echo "You must select 1-7"
        echo ""
    fi
done
