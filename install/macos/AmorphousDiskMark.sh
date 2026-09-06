# brew install amorphousdiskmark # Cask 'amorphousdiskmark' has been disabled because it is now exclusively distributed on the Mac App Store! It was disabled on 2024-12-16.
# mas install 1168254295 # AmorphousDiskMark can't be installed in DE: "This app is currently not available in your country or region."; https://apps.apple.com/us/app/amorphousdiskmark/id1168254295

# Download and install AmorphousDiskMark
curl -fsSL "https://katsurashareware.com/eudsa/AmorphousDiskMark.zip" -o /tmp/AmorphousDiskMark.zip
unzip -qo /tmp/AmorphousDiskMark.zip -d /Applications/
rm -f /tmp/AmorphousDiskMark.zip

# Remove macOS Gatekeeper quarantine flag
xattr -dr com.apple.quarantine /Applications/AmorphousDiskMark.app

# 3402R 3155W on 1TB M1 MBA
# 167W 273R on 128GB USB stick SanDisk Ultra Dual Luxe
