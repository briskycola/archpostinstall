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

echo "Installing CUPS for printing support"
pacman -S --noconfirm cups cups-pdf nss-mdns print-manager system-config-printer    > /dev/null 2>&1
systemctl enable cups.socket                                                        > /dev/null 2>&1
systemctl enable avahi-daemon.socket                                                > /dev/null 2>&1

# The following command will modify /etc/nsswitch.conf
# to enable support for DNS-SD/mDNS.
#
# Some printers require the use of mDNS in order
# to be discovered over the network.
#
# If you do not want or need mDNS functionality,
# simply remove the following lines in /etc/nsswitch.conf
#
# mdns_minimal [NOTFOUND=return]
sed -i '11c\hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns' /etc/nsswitch.conf
