#!/bin/bash
set -e

echo "=== Starting Flutter Web Build for Vercel ==="

# Check if flutter is already installed
if ! command -v flutter &> /dev/null
then
    echo "Installing Flutter SDK (stable branch)..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 _flutter
    export PATH="$PATH:`pwd`/_flutter/bin"
else
    echo "Flutter already present in PATH."
fi

# Print flutter version info
flutter --version

echo "Fetching Flutter dependencies..."
flutter pub get

echo "Building Flutter Web release bundle..."
flutter build web --release

echo "=== Flutter Web Build Completed Successfully! ==="
