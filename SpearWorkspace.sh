#!/usr/bin/env bash
# =====================================================================
#   ___  _   _ ____   ___  ____   ___  ____   ___  ____  
#  / _ \| | | |  _ \ / _ \| __ ) / _ \|  _ \ / _ \/ ___| 
# | | | | | | | |_) | | | |  _ \| | | | |_) | | | \___ \ 
# | |_| | |_| |  _ <| |_| | |_) | |_| |  _ <| |_| |___) |
#  \___/ \___/|_| \_\\___/|____/ \___/|_| \_\\___/|____/ 
#
#  Label   : Ouroboros
#  Repo    : https://github.com
#  License : MIT
# =====================================================================
echo "MADE BY OUROBOROS A.K.A. WHEREISROOOT?"


# GEO-BLOCKS
read -p "Is Cisco geo-blocked in your country? (y/n): " geo
if [[ "$geo" == [Yy] ]]; then
    echo "Welcome, comrade XD"
    sudo dnf config-manager setopt fedora-cisco-openh264.enabled=0
else
    echo "All clear, moving on..."
fi

read -p "Down to use your fingerprint? (y/n):" finger
if [[ "$finger" ==  [Yy] ]]; then 
    fprintd-enroll
else
    echo "Fair enough, skip."
fi
# REPOS
echo "Adding RPM Fusion (free) repo..."
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
echo "Adding RPM Fusion (non-free) repo..."
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf upgrade --refresh -y
echo "Tweaking DNF config..."
sudo dnf config-manager setopt max_parallel_downloads=10 fastestmirror=True defaultyes=True


# PACKAGES
echo "Installing core packages..."
sudo dnf install -C telegram-desktop strace nmap dig podman-compose vim wayland-devel wayland-protocols-devel libxkbcommon-devel pixman-devel -y
sudo dnf install -C mesa-libGL-devel glslang wayland-utils git git-lfs gdb valgrind cmake -y 
sudo dnf install -C curl ninja-build htop btop gcc make pkgconf -y
echo "Nuking malcontent..."
sudo dnf remove malcontent-control -y
echo "Installing VSCodium..."
sudo tee -a /etc/yum.repos.d/vscodium.repo << 'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
sudo dnf install -C codium -y


# FLATPAK
echo "Setting up Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org


# GAMES
read -p "Wanna play some games? (y/n): " games
if [[ "$games" == [Yy] ]]; then
    sudo dnf install -C lutris wine vulkan-loader -y
    flatpak remote-add --if-not-exists freesmlauncher https://flatpak.freesmlauncher.org/freesmlauncher.flatpakrepo
    flatpak install -y freesmlauncher org.freesmlauncher.FreesmLauncher
    mkdir -p ~/Games
else
    echo "Fair enough, skipping games."
fi 


# FONTS
echo "Installing JetBrains Mono fonts..."
sudo dnf install jetbrains-mono-fonts -y



# GNOME SETTINGS
echo "Making GNOME actually usable..."
gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono 10'
gsettings set org.gnome.desktop.interface document-font-name 'JetBrains Mono 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
sudo systemctl --global mask gnome-initial-setup-first-login.service
sudo dnf remove gnome-tour -y
gsettings set org.gnome.mutter edge-tiling false
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface accent-color 'slate'
gdbus call --system   --dest org.freedesktop.Accounts   --object-path /org/freedesktop/Accounts/User$(id -u)   --method org.freedesktop.Accounts.User.SetIconFile  "$PWD/avatar.jpg"


# APPEARANCE & TERMINAL
echo "Setting wallpaper... we will eat the moon! <3"
WALLPAPER="$(realpath moon.jpg)"
gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
gsettings set org.gnome.desktop.background picture-options 'zoom'
echo "Applying terminal theme..."
UUID=$(gsettings get org.gnome.Ptyxis default-profile-uuid | tr -d "'")
dconf write "/org/gnome/Ptyxis/Profiles/$UUID/palette" "'vscode'"


# APP MENU CLEANUP
echo "Decluttering the app menu..."
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/btop.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/htop.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Weather.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Maps.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Characters.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.fedoraproject.MediaWriter.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Contacts.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.TextEditor.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Calendar.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.clocks.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Connections.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.DiskUtility.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.SystemMonitor.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.SimpleScan.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Software.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Logs.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.baobab.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Decibels.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Papers.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.font-viewer.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Loupe.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/wine-mime-msi.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/wine-notepad.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/wine-oleview.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/wine-regedit.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/wine-uninstaller.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/wine-wineboot.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/wine-cfg.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/wine-wordpad.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/wine-winhelp.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/wine-winefile.desktop'
sudo bash -c 'echo "NoDisplay=true" >> /usr/share/applications/org.gnome.Yelp.desktop'
sudo rm -f /usr/share/applications/wine-winecfg.desktop
sudo rm -f /usr/share/applications/org.gnome.Papers.desktop


# OS SETTINGS
echo "Setting hostname to SPEAR..."
sudo hostnamectl set-hostname spear


# REBOOT
read -p "Reboot now? (y/n): " answer
if [[ "$answer" == [Yy] ]]; then
    echo "Rebooting..."
    sudo reboot
else 
    echo "No worries, enjoy your setup!"
    curl ascii.live/rick
fi
