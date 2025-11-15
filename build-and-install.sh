#!/bin/bash

# Habits Tracker - Build and Install Script
# This builds a release version and installs it to /Applications

set -e

echo "🔨 Building Habits Tracker (Release)..."

# Close any running instances
killall "Habits Tracker" 2>/dev/null || true

swift build -c release

echo "📦 Creating app bundle..."
APP_NAME="Habits Tracker"
BUNDLE_DIR=".build/release/$APP_NAME.app"
CONTENTS_DIR="$BUNDLE_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

# Create bundle structure
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy executable
cp .build/release/HabitsTracker "$MACOS_DIR/$APP_NAME"

# Create Info.plist
cat > "$CONTENTS_DIR/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.andreivince.habits-tracker</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>© 2025 Andrei Vince</string>
</dict>
</plist>
EOF

# Create PkgInfo
echo "APPL????" > "$CONTENTS_DIR/PkgInfo"

echo "✅ App bundle created at: $BUNDLE_DIR"

# Install to Applications (optional)
read -p "Install to /Applications? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📲 Installing to /Applications..."
    rm -rf "/Applications/$APP_NAME.app"
    cp -R "$BUNDLE_DIR" "/Applications/"
    echo "✅ Installed to /Applications/$APP_NAME.app"
    echo "🚀 You can now find 'Habits Tracker' in your Applications folder!"
else
    echo "ℹ️  You can manually copy $BUNDLE_DIR to /Applications"
fi

echo ""
echo "✨ Build complete!"
echo "📍 App bundle: $BUNDLE_DIR"
echo "💡 Tip: Drag it to your Applications folder or run this script again"
