# Build & Distribution Guide

## Quick Start - Install on Your Mac

### Option 1: Using the Build Script (Easiest)
```bash
./build-and-install.sh
```

This will:
1. Build a release version
2. Create an app bundle
3. Optionally install to `/Applications`

### Option 2: Manual Build
```bash
# Build release version
swift build -c release

# Run the executable
.build/release/HabitsTracker
```

## Installing to Applications Folder

After running the build script, you can:
1. Find the app at `.build/release/Habits Tracker.app`
2. Drag it to `/Applications`
3. Double-click to launch like any other Mac app

## Your Data is Private

**Your habits won't appear in other people's installations because:**
- Habits are stored in UserDefaults (sandboxed per-user)
- Each installation creates its own data store
- Data location: `~/Library/Preferences/com.andreivince.habits-tracker.plist`
- When you share the app, others get a fresh, empty state

## Distribution Options

### For Personal Use
- Use the build script above
- Keep the `.app` in your Applications folder
- Your data stays on your machine

### For Friends/Family
1. Build the app with the script
2. Compress the `.app` bundle: `zip -r HabitsTracker.zip ".build/release/Habits Tracker.app"`
3. Share the `.zip` file
4. They extract and drag to Applications
5. **They start with zero habits** (fresh installation)

### For Public Distribution
If you want to distribute publicly:

1. **Sign the app** (requires Apple Developer account $99/year):
   ```bash
   codesign --deep --force --sign "Developer ID Application: Your Name" "Habits Tracker.app"
   ```

2. **Notarize** (so macOS doesn't block it):
   - Submit to Apple for notarization
   - Users won't see security warnings

3. **Alternative: Open Source**
   - Share the source code (this folder)
   - Users build it themselves
   - No signing required

## Build for Different Macs

The current build works on your Mac architecture. For universal distribution:

```bash
# Build for Apple Silicon + Intel
swift build -c release --arch arm64 --arch x86_64
```

## Troubleshooting

### "App is damaged and can't be opened"
If others see this when downloading:
```bash
xattr -cr "/Applications/Habits Tracker.app"
```

### App won't launch
- Check macOS version (requires macOS 13.0+)
- Right-click → Open (first time only)

## Development vs Release

**Development** (what you've been doing):
- Run with `swift build` or Xcode
- Faster rebuilds
- Includes debug symbols

**Release** (for distribution):
- Run with `swift build -c release`
- Optimized for performance
- Smaller file size
- No debug overhead

## File Locations

- **App Bundle**: `.build/release/Habits Tracker.app`
- **Executable**: `.build/release/HabitsTracker`
- **Your Habits Data**: `~/Library/Preferences/com.andreivince.habits-tracker.plist`

---

**Quick Commands:**
```bash
# Build and install
./build-and-install.sh

# Just build
swift build -c release

# Clean and rebuild
swift package clean && swift build -c release

# Run without installing
.build/release/HabitsTracker
```
