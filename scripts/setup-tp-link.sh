#!/bin/bash
# setup-tp-link.sh
# Script to set up TP-Link Archer T2U Nano (RTL8811AU) WiFi on Arch Linux

set -e

echo "=== Updating system ==="
sudo pacman -Syu --noconfirm

echo "=== Installing required tools ==="
sudo pacman -S --needed --noconfirm base-devel dkms linux-headers git usbutils pciutils networkmanager

# Ensure NetworkManager is enabled
echo "=== Enabling NetworkManager ==="
sudo systemctl enable --now NetworkManager

# Check if yay is installed, otherwise build it
if ! command -v yay &> /dev/null; then
    echo "=== yay not found, installing yay ==="
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
fi

echo "=== Installing RTL8811AU driver (rtl88xxau-aircrack-dkms-git) ==="
yay -S --noconfirm rtl88xxau-aircrack-dkms-git

echo "=== Loading driver module ==="
sudo modprobe 8812au

echo "=== Checking Wi-Fi interfaces ==="
ip link | grep wl || echo "No wireless interfaces found — check driver support."

echo "=== Setup complete! Launch 'nmtui' to connect to Wi-Fi. ==="
