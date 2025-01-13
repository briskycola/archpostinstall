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

# Install PipeWire
echo "Installing PipeWire audio server"
pacman -S --noconfirm pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber   > /dev/null 2>&1

# Install KDE along with some applications and tools
echo "Installing KDE along with some applications and tools"
pacman -S --noconfirm plasma-desktop dolphin dolphin-plugins ffmpegthumbs ark konsole okular gwenview \
kscreen firefox mpv yt-dlp ffmpeg zed kde-gtk-config breeze-gtk plasma-pa plasma-nm power-profiles-daemon  \
usbutils partitionmanager ufw sddm sddm-kcm                                             > /dev/null 2>&1

# Install Bluetooth utilities if Bluetooth is supported
bash installBluetooth.sh

# Install CUPS for printing support
bash installCUPS.sh
