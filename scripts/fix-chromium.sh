#!/bin/bash

echo "==> 1. Installing Intel media drivers and tools..."
sudo zypper install -y intel-media-driver libva-utils intel-gpu-tools

echo "==> 2. Setting up local directories..."
mkdir -p ~/.local/share/applications/
mkdir -p ~/.config/

echo "==> 3. Creating a clean, Wayland-optimized Chromium desktop file..."
# This bypasses openSUSE's broken template entirely and hardcodes the GPU/Wayland flags
cat << 'EOF' > ~/.local/share/applications/chromium-browser.desktop
[Desktop Entry]
Version=1.0
Name=Chromium
GenericName=Web Browser
Comment=Access the Internet
Exec=env LIBVA_DRIVER_NAME=iHD chromium-browser --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,VaapiVideoDecoder,VaapiIgnoreDriverChecks --use-gl=egl %U
Terminal=false
Type=Application
Icon=chromium-browser
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/about;x-scheme-handler/unknown;
StartupNotify=true
EOF

echo "==> 4. Updating local application cache..."
update-desktop-database ~/.local/share/applications

echo "==> 5. Hardcoding the default browser in mimeapps.list..."
# Ensure the file and header exist
touch ~/.config/mimeapps.list
grep -q "\[Default Applications\]" ~/.config/mimeapps.list || echo "[Default Applications]" >> ~/.config/mimeapps.list

# Remove any existing browser defaults so we don't create duplicates
sed -i '/text\/html/d; /x-scheme-handler\/http/d; /x-scheme-handler\/https/d; /x-scheme-handler\/about/d; /x-scheme-handler\/unknown/d' ~/.config/mimeapps.list

# Inject Chromium as the absolute default
cat << 'EOF' >> ~/.config/mimeapps.list
text/html=chromium-browser.desktop
x-scheme-handler/http=chromium-browser.desktop
x-scheme-handler/https=chromium-browser.desktop
x-scheme-handler/about=chromium-browser.desktop
x-scheme-handler/unknown=chromium-browser.desktop
EOF

echo "==> 6. Locking it in with xdg-settings..."
# Temporarily clear $BROWSER so xdg-settings doesn't panic, then set the default
unset BROWSER
xdg-settings set default-web-browser chromium-browser.desktop

echo "==> 7. Setting the BROWSER environment variable permanently..."
# Only add it to .bashrc if it isn't already there
grep -q "export BROWSER=chromium-browser" ~/.bashrc || echo "export BROWSER=chromium-browser" >> ~/.bashrc

echo ""
echo "================================================================"
echo "✅ SUCCESS: Chromium is optimized for Wayland, Intel hardware "
echo "acceleration is enabled, and Firefox has been defeated."
echo "Please close your terminal and open a new one to apply changes."
echo "================================================================"
