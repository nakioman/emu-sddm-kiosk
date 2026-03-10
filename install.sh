#!/bin/bash

echo ""

echo " (1) - Install Windows 7 SDDM Theme"
echo " (2) - Install Required Segoe UI fonts"
echo " (3) - Install Windows Cursor Icons"
echo " (4) - Install Kiosk Session Files"

echo ""

echo "Please type only number(s) to pick options: (e.g: "1 2")"
   
read -p ":: " input

function sddm() {

    sudo wget -P /usr/share/sddm/themes https://github.com/birbkeks/win7-sddm-theme/releases/download/1.0/win7-sddm-theme.tar.gz -nc

    sudo tar -xzf /usr/share/sddm/themes/win7-sddm-theme.tar.gz -C /usr/share/sddm/themes

    sudo rm -rf /usr/share/sddm/themes/win7-sddm-theme.tar.gz

    sudo rm -rf /usr/share/sddm/themes/win7-sddm-theme/.git/

    edit
}

function edit() {

    if [[ $XDG_CURRENT_DESKTOP == "KDE" ]]; then

    sudo sed -i '/Current=/d' /etc/sddm.conf.d/kde_settings.conf

    sudo sed -i '/Theme]/a\
Current=win7-sddm-theme
' /etc/sddm.conf.d/kde_settings.conf

    else

    sudo sed -i '/Current=/d' /etc/sddm.conf

    sudo sed -i '/Theme]/a\
Current=win7-sddm-theme
' /etc/sddm.conf

    fi
}

function font() {
    # Not installed locally because I can't stand to see this font on Github and other websites, I couldn't find a way to disable this font for browser. I'm used to see Noto Sans too much I guess. You can go to this fonts files and install it locally if you want to and this theme will still work.

    sudo wget -P /usr/share/sddm/themes/win7-sddm-theme/fonts https://github.com/birbkeks/win7-sddm-theme/raw/main/fonts/segoeui.ttf -nc

    sudo wget -P /usr/share/sddm/themes/win7-sddm-theme/fonts https://github.com/birbkeks/win7-sddm-theme/raw/main/fonts/segoeuil.ttf -nc
}

function sessions() {
    THEME_DIR="/usr/share/sddm/themes/win7-sddm-theme"
    XSESSIONS_DIR="/usr/share/xsessions"

    sudo mkdir -p "$XSESSIONS_DIR"

    for f in "$THEME_DIR/sessions/"*.desktop; do
        [ -f "$f" ] || continue
        filename=$(basename "$f")
        sudo ln -sf "$f" "$XSESSIONS_DIR/$filename"
        echo "Linked $filename -> $XSESSIONS_DIR/$filename"
    done

    # Enable QML file reading for .desktop Comment parsing
    SDDM_CONF_DIR="/etc/sddm.conf.d"
    KIOSK_CONF="$SDDM_CONF_DIR/kiosk.conf"
    sudo mkdir -p "$SDDM_CONF_DIR"
    if [ ! -f "$KIOSK_CONF" ]; then
        echo "[General]" | sudo tee "$KIOSK_CONF" > /dev/null
        echo "GreeterEnvironment=QML_XHR_ALLOW_FILE_READ=1" | sudo tee -a "$KIOSK_CONF" > /dev/null
        echo "Created $KIOSK_CONF with QML_XHR_ALLOW_FILE_READ=1"
    else
        echo "$KIOSK_CONF already exists, skipping."
    fi

    echo "Kiosk session files installed. Restart SDDM to pick them up."
}

function cursor() {
    sudo wget -P /usr/share/icons https://github.com/birbkeks/windows-cursors/releases/download/1.0/windows-cursors.tar.gz -nc

    sudo tar -xzf /usr/share/icons/windows-cursors.tar.gz -C /usr/share/icons/

    sudo cp /usr/share/icons/windows-cursors/index.theme /usr/share/icons/default/index.theme

    sudo cp -r /usr/share/icons/windows-cursors/cursors /usr/share/icons/default

    sudo rm -rf /usr/share/icons/windows-cursors

    sudo rm -f /usr/share/icons/windows-cursors.tar.gz
}

if [[ $input == "1" ]]; then

    echo ""
    echo "Installing Windows 10 SDDM Theme..."
    echo ""

    sddm

    echo "Done."

elif [[ $input == "2" ]]; then

    echo ""
    echo "Required Segoe UI fonts..."
    echo ""

    font

    echo "Done."

elif [[ $input == "3" ]]; then

    echo ""
    echo "Install Windows Cursor Icons..."
    echo ""

    cursor

    echo "Done."

elif [[ $input == "1 2" ]]; then

    echo ""
    echo "Install Windows Cursor Icons and Required Segoe UI fonts..."
    echo ""

    sddm
    font

    echo "Done."

elif [[ $input == "1 2 3" ]]; then

    echo ""
    echo "Install Windows Cursor Icons, Required Segoe UI fonts and Windows Cursor Icons..."
    echo ""

    sddm
    font
    cursor

    echo "Done."

elif [[ $input == "2 3" ]]; then

    echo ""
    echo "Required Segoe UI fonts and Windows Cursor Icons..."
    echo ""

    font
    cursor

    echo "Done."

elif [[ $input == "4" ]]; then

    echo ""
    echo "Installing Kiosk Session Files..."
    echo ""

    sessions

    echo "Done."

else

    echo ""
    echo "Invalid number, please try again."; exit 1

fi
