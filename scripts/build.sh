#!/usr/bin/env bash

# EmoSense Flutter App Build Script
# 
# This script helps build the Flutter app for different environments
# and platforms with the correct backend configuration.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Default values
ENVIRONMENT="production"
PLATFORM="android"
BUILD_TYPE="release"

# Help function
show_help() {
    echo "EmoSense Flutter Build Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -e, --environment   Environment (development|production) [default: production]"
    echo "  -p, --platform      Platform (android|ios|web) [default: android]"
    echo "  -t, --type         Build type (debug|release) [default: release]"
    echo "  -h, --help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Build Android release with production backend"
    echo "  $0 -e development -t debug            # Build Android debug with local backend"
    echo "  $0 -p ios -e production               # Build iOS release with production backend"
    echo "  $0 -p web -e production               # Build web with production backend"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        -t|--type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate inputs
if [[ ! "$ENVIRONMENT" =~ ^(development|production)$ ]]; then
    print_error "Invalid environment: $ENVIRONMENT"
    echo "Valid environments: development, production"
    exit 1
fi

if [[ ! "$PLATFORM" =~ ^(android|ios|web)$ ]]; then
    print_error "Invalid platform: $PLATFORM"
    echo "Valid platforms: android, ios, web"
    exit 1
fi

if [[ ! "$BUILD_TYPE" =~ ^(debug|release)$ ]]; then
    print_error "Invalid build type: $BUILD_TYPE"
    echo "Valid build types: debug, release"
    exit 1
fi

print_status "Starting build process..."
print_status "Environment: $ENVIRONMENT"
print_status "Platform: $PLATFORM"
print_status "Build Type: $BUILD_TYPE"

# Switch to correct environment
print_status "Switching to $ENVIRONMENT environment..."
if command -v dart &> /dev/null; then
    dart scripts/switch_environment.dart $ENVIRONMENT
else
    print_warning "Dart not found, manually copying environment file..."
    cp ".env.$ENVIRONMENT" ".env"
fi

# Verify environment file exists
if [[ ! -f ".env" ]]; then
    print_error "Environment file .env not found after switching"
    exit 1
fi

# Show backend URL being used
BACKEND_URL=$(grep "API_BASE_URL=" .env | cut -d'=' -f2)
print_status "Using backend: $BACKEND_URL"

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean
flutter pub get

# Run code generation if needed
if [[ -f "pubspec.yaml" ]] && grep -q "build_runner" pubspec.yaml; then
    print_status "Running code generation..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
fi

# Build based on platform and type
print_status "Building $PLATFORM $BUILD_TYPE..."

case "$PLATFORM" in
    android)
        if [[ "$BUILD_TYPE" == "release" ]]; then
            flutter build apk --release
            BUILD_OUTPUT="build/app/outputs/flutter-apk/app-release.apk"
        else
            flutter build apk --debug
            BUILD_OUTPUT="build/app/outputs/flutter-apk/app-debug.apk"
        fi
        ;;
    ios)
        if [[ "$BUILD_TYPE" == "release" ]]; then
            flutter build ios --release --no-codesign
            BUILD_OUTPUT="build/ios/iphoneos/Runner.app"
        else
            flutter build ios --debug --no-codesign
            BUILD_OUTPUT="build/ios/iphoneos/Runner.app"
        fi
        ;;
    web)
        if [[ "$BUILD_TYPE" == "release" ]]; then
            flutter build web --release
        else
            flutter build web --debug
        fi
        BUILD_OUTPUT="build/web"
        ;;
esac

# Verify build output
if [[ -e "$BUILD_OUTPUT" ]]; then
    print_success "Build completed successfully!"
    print_success "Output location: $BUILD_OUTPUT"
    
    # Show build info
    if [[ "$PLATFORM" == "android" ]]; then
        BUILD_SIZE=$(du -h "$BUILD_OUTPUT" | cut -f1)
        print_status "APK size: $BUILD_SIZE"
    fi
    
    # Show deployment instructions
    echo ""
    print_status "Deployment Instructions:"
    
    case "$PLATFORM" in
        android)
            echo "  📱 Install APK: adb install $BUILD_OUTPUT"
            echo "  🏪 Upload to Play Store: Use the APK file"
            ;;
        ios)
            echo "  📱 Deploy to device: Use Xcode or fastlane"
            echo "  🏪 Upload to App Store: Use Xcode or Application Loader"
            ;;
        web)
            echo "  🌐 Deploy to hosting: Upload build/web contents"
            echo "  🚀 Firebase Hosting: firebase deploy"
            echo "  📡 Netlify: Drag and drop build/web folder"
            ;;
    esac
    
    if [[ "$ENVIRONMENT" == "production" ]]; then
        echo ""
        print_warning "Production Build Notes:"
        echo "  • App will connect to Render backend"
        echo "  • First API calls may be slow due to cold starts"
        echo "  • Mock data is disabled"
        echo "  • Debug logging is disabled"
    fi
    
else
    print_error "Build failed! Output not found at $BUILD_OUTPUT"
    exit 1
fi

print_success "Build process completed!"
