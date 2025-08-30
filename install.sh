#!/bin/bash

## DOWNLOAD AND INSTALL ANDROID STUDIO ON LINUX ##

# Vars
SYS_USER=$(whoami)
DOWNLOAD_DIR="$(pwd)"
JSON_URL="https://developer.android.com/studio"

echo "[+] Searching the latest version of Android Studio..."

# Get the download URL for Linux
DOWNLOAD_URL=$(curl -s "$JSON_URL" | grep -oP 'https://.*?android-studio-.*?linux\.tar\.gz')

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Cannot get the download URL"
    echo "[-] EXITING"
    exit 1
fi

echo "URL finded: $DOWNLOAD_URL"

# # Crear directorio temporal
# mkdir -p "$TMP_DIR"

# Download Android Studio
echo "[+] Downloading Android Studio..."
if [$]
curl -L "$DOWNLOAD_URL" -o "$DOWNLOAD_DIR/android-studio.tar.gz"
if [ $? -ne 0 ]; then
    echo "Download failed..."
    echo "[-] EXITING"
    exit 1
fi
echo "Download completed"

# Extract (require superuser privileges)
echo "[+] Preparing to extract Android Studio..."
echo "Where do you want to install Android Studio?"
read -p "ENTER to default (/opt/android-studio): " USER_PATH

if [ "$USER_PATH" == "" && "$SYS_USER" == "root"]; then
    echo "[+] Extracting in $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
    tar -xvzf "$DOWNLOAD_DIR/android-studio.tar.gz" -C "$INSTALL_DIR"
elif [ "$USER_PATH" == "" && "$SYS_USER" != "root"]; then
    echo "[+] Extracting in $INSTALL_DIR..."
    sudo mkdir -p "$INSTALL_DIR"
    sudo tar -xvzf "$DOWNLOAD_DIR/android-studio.tar.gz" -C "$INSTALL_DIR"
elif [ "$USER_PATH" != "" && "$SYS_USER" == "root"]; then
    INSTALL_DIR="$USER_PATH/android-studio"
    echo "[+] Extracting in $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
    tar -xvzf "$DOWNLOAD_DIR/android-studio.tar.gz" -C "$INSTALL_DIR"
elif [ "$USER_PATH" != "" && "$SYS_USER" != "root"]; then
    INSTALL_DIR="$USER_PATH/android-studio"
    echo "[+] Extracting in $INSTALL_DIR..."
    sudo mkdir -p "$INSTALL_DIR"
    sudo tar -xvzf "$DOWNLOAD_DIR/android-studio.tar.gz" -C "$INSTALL_DIR"
fi

echo "Deleting android-studio.tar.gz..."

echo "[+] Installation finished in $INSTALL_DIR"
echo "..."

## CEATE DESKTOP ENTRY ##
echo "[+] Creating desktop entry..."
DESKTOP_FILE="/usr/share/applications/android-studio.desktop"

# Create the desktop entry file
if [ "$SYS_USER" == "root"]; then
    echo "[Desktop Entry]
    Name=Android Studio
    Comment=Android Studio IDE for Linux
    Type=Application
    Icon=$INSTALL_DIR/android-studio/bin/studio.png
    Exec=$INSTALL_DIR/android-studio/bin/studio.sh
    StartupNotify=true
    Terminal=false
    Categories=Development;IDE;" > "$DESKTOP_FILE"
elif [ "$SYS_USER" != "root"]; then
    sudo echo "[Desktop Entry]
    Name=Android Studio
    Comment=Android Studio IDE for Linux
    Type=Application
    Icon=$INSTALL_DIR/android-studio/bin/studio.png
    Exec=$INSTALL_DIR/android-studio/bin/studio.sh
    StartupNotify=true
    Terminal=false
    Categories=Development;IDE;" > "$DESKTOP_FILE"
fi

if [ "$SYS_USER" == "root"]; then
    chmod +x $DESKTOP_FILE
elif [ "$SYS_USER" != "root"]; then
    sudo chmod +x $DESKTOP_FILE
fi
echo "Desktop entry created at $DESKTOP_FILE"
echo "You can now launch Android Studio from your application menu"
echo "[+] INSTALLATION AND CONFIGURATION OF ANDROID STUDIO FOR LINUX FINISHED"