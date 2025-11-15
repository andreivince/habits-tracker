# Update Guide

## Updating Your Installed App

### Quick Update (Most Common)

When you make code changes and want to update the installed app:

```bash
# 1. Make your code changes
# 2. Close the running app (if open)
# 3. Rebuild and reinstall
./build-and-install.sh
```

**That's it!** Your habits data is preserved automatically.

### Why Your Data Stays Safe

Your habits are stored **separately** from the app:
- **App location**: `/Applications/Habits Tracker.app` (gets replaced)
- **Data location**: `~/Library/Preferences/com.andreivince.habits-tracker.plist` (stays untouched)

When you rebuild:
- ✅ New code is installed
- ✅ Old data remains
- ✅ App loads your existing habits

## Update Workflow

### 1. During Development
```bash
# Quick iteration - no install needed
swift build
.build/debug/HabitsTracker

# When ready to update your installed app
./build-and-install.sh
```

### 2. Testing Updates
```bash
# Close the app first
killall "Habits Tracker" 2>/dev/null || true

# Rebuild and install
./build-and-install.sh
```

### 3. Clean Rebuild (if needed)
```bash
# Remove old build artifacts
swift package clean

# Rebuild from scratch
./build-and-install.sh
```

## Version Management

### Update Version Number

Edit `Package.swift` or the build script to increment versions:

**In build script (build-and-install.sh), update:**
```xml
<key>CFBundleShortVersionString</key>
<string>1.1</string>  <!-- User-facing version -->
<key>CFBundleVersion</key>
<string>2</string>     <!-- Build number -->
```

### Version Examples
- `1.0` → First release
- `1.1` → Small updates (new features)
- `1.1.1` → Bug fixes
- `2.0` → Major changes

## Distributing Updates

### For Others Using Your App

**Option 1: Simple Replacement**
1. Build new version: `./build-and-install.sh`
2. Zip it: `zip -r HabitsTracker-v1.1.zip ".build/release/Habits Tracker.app"`
3. Share with users
4. They replace old app with new one
5. **Their data is preserved** (stored separately)

**Option 2: Versioned Releases**
```bash
# Build with version tag
./build-and-install.sh
mv ".build/release/Habits Tracker.app" "Habits-Tracker-v1.1.app"
zip -r HabitsTracker-v1.1.zip "Habits-Tracker-v1.1.app"
```

## Data Migration (If Needed)

If you change the data structure (like adding new properties to Habit):

### Your Existing Code Already Handles It! ✅

The `Habit` struct uses `Codable` with default values:
```swift
var goalMinutes: Int? = nil  // New property
```

**What happens when users update:**
1. Old habits load (missing `goalMinutes`)
2. Swift uses default value `nil`
3. Everything works!
4. New habits can use the new property

### If You Need Custom Migration

Add to `HabitStore.load()`:
```swift
private func load() {
    guard let data = UserDefaults.standard.data(forKey: storageKey),
          let decoded = try? JSONDecoder().decode([Habit].self, from: data) else {
        // Migration from old version
        if let oldData = UserDefaults.standard.data(forKey: "oldStorageKey") {
            // Migrate old data format
        }
        return
    }
    habits = decoded
}
```

## Troubleshooting Updates

### App Won't Launch After Update
```bash
# Clear app cache
rm -rf ~/Library/Caches/com.andreivince.habits-tracker

# Reinstall
./build-and-install.sh
```

### Data Not Showing
```bash
# Check if data exists
defaults read com.andreivince.habits-tracker

# If you see habits data, it's there!
```

### Clean Install (Nuclear Option)
```bash
# Remove app
rm -rf "/Applications/Habits Tracker.app"

# Remove ALL data (⚠️ deletes your habits!)
defaults delete com.andreivince.habits-tracker

# Fresh install
./build-and-install.sh
```

## Best Practices

### Before Distributing Updates
1. ✅ Test on your machine first
2. ✅ Increment version number
3. ✅ Test data migration (create habits, update, check they're still there)
4. ✅ Note changes in release notes

### Development Workflow
```bash
# Day-to-day: quick builds
swift build
.build/debug/HabitsTracker

# Before sharing: release build
./build-and-install.sh

# Test the installed version
open "/Applications/Habits Tracker.app"
```

## Automatic Updates (Future)

To add auto-update functionality later, you could:
1. Use Sparkle framework (popular for Mac apps)
2. Check for updates on launch
3. Download and install automatically

But for now, manual updates work perfectly!

---

**TL;DR:**
```bash
# Update your installed app
./build-and-install.sh

# Your habits are safe - they're stored separately!
```
