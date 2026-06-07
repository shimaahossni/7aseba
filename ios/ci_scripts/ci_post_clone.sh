#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The clone directory is the ios folder. We need to go up to the Flutter root.
cd ..

# Clone Flutter stable branch
echo "Downloading Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable

# Add Flutter tool to path
export PATH="$PATH:`pwd`/flutter/bin"

# Pre-download development binaries
flutter precache --ios

# Resolve Flutter dependencies
echo "Fetching dependencies..."
flutter pub get

# Install iOS CocoaPods
echo "Installing CocoaPods dependencies..."
cd ios
pod install

echo "Xcode Cloud Pre-clone Setup Complete!"
exit 0
