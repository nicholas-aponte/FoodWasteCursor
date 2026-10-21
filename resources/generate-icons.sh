#!/bin/bash
# Generate iOS app icons and splash screens from SVG sources
# Requires: ImageMagick (convert command) or rsvg-convert

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="$SCRIPT_DIR"
IOS_ASSETS_DIR="$SCRIPT_DIR/../ios/App/App/Assets.xcassets"

echo "Generating iOS icons and splash screens..."

# Check for required tools
if command -v rsvg-convert &> /dev/null; then
    SVG_CONVERTER="rsvg-convert"
elif command -v convert &> /dev/null; then
    SVG_CONVERTER="convert"
else
    echo "Error: Neither rsvg-convert nor ImageMagick (convert) found."
    echo "Install with: brew install librsvg  OR  brew install imagemagick"
    exit 1
fi

# Generate app icon (1024x1024 for iOS)
echo "Generating app icon..."
if [ "$SVG_CONVERTER" = "rsvg-convert" ]; then
    rsvg-convert -w 1024 -h 1024 "$RESOURCES_DIR/icon.svg" > "$IOS_ASSETS_DIR/AppIcon.appiconset/AppIcon-1024.png"
else
    convert -background none -resize 1024x1024 "$RESOURCES_DIR/icon.svg" "$IOS_ASSETS_DIR/AppIcon.appiconset/AppIcon-1024.png"
fi

# Generate splash screens (2732x2732 for iPad Pro)
echo "Generating splash screens..."
if [ "$SVG_CONVERTER" = "rsvg-convert" ]; then
    rsvg-convert -w 2732 -h 2732 "$RESOURCES_DIR/splash.svg" > "$IOS_ASSETS_DIR/Splash.imageset/splash-2732x2732.png"
    cp "$IOS_ASSETS_DIR/Splash.imageset/splash-2732x2732.png" "$IOS_ASSETS_DIR/Splash.imageset/splash-2732x2732-1.png"
    cp "$IOS_ASSETS_DIR/Splash.imageset/splash-2732x2732.png" "$IOS_ASSETS_DIR/Splash.imageset/splash-2732x2732-2.png"
else
    convert -background none -resize 2732x2732 "$RESOURCES_DIR/splash.svg" "$IOS_ASSETS_DIR/Splash.imageset/splash-2732x2732.png"
    cp "$IOS_ASSETS_DIR/Splash.imageset/splash-2732x2732.png" "$IOS_ASSETS_DIR/Splash.imageset/splash-2732x2732-1.png"
    cp "$IOS_ASSETS_DIR/Splash.imageset/splash-2732x2732.png" "$IOS_ASSETS_DIR/Splash.imageset/splash-2732x2732-2.png"
fi

echo "Done! Icons generated in $IOS_ASSETS_DIR"
echo ""
echo "To use custom branding:"
echo "1. Replace resources/icon.svg with your app icon (1024x1024)"
echo "2. Replace resources/splash.svg with your splash screen"
echo "3. Run this script again: ./resources/generate-icons.sh"
