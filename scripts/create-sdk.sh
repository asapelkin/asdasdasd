#!/usr/bin/env bash
# create-sdk.sh – Create the Ubuntu 24.04 base rootfs and SDK directories
# that are used as local sources for the BuildStream elements.
#
# Usage:
#   sudo bash scripts/create-sdk.sh          # create both
#   sudo bash scripts/create-sdk.sh base     # create only ubuntu-base
#   sudo bash scripts/create-sdk.sh sdk      # create only sdk
#
# Requirements: debootstrap, sudo
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
FILES_DIR="$PROJECT_ROOT/files"

UBUNTU_RELEASE="noble"
UBUNTU_MIRROR="http://archive.ubuntu.com/ubuntu"

BUILD_PACKAGES=(
    build-essential
    pkg-config
    git
    # Python build deps
    libssl-dev
    zlib1g-dev
    libffi-dev
    libreadline-dev
    libsqlite3-dev
    libncurses5-dev
    libbz2-dev
    liblzma-dev
    libexpat1-dev
    uuid-dev
    # QEMU build deps
    libglib2.0-dev
    libpixman-1-dev
    ninja-build
    meson
    python3
    python3-pip
    libslirp-dev
    libcap-ng-dev
    libseccomp-dev
)

TARGET="${1:-all}"

create_ubuntu_base() {
    local DEST="$FILES_DIR/ubuntu-base"
    if [ -d "$DEST" ]; then
        echo "[ubuntu-base] Already exists at $DEST, skipping."
        return
    fi
    echo "[ubuntu-base] Creating minimal Ubuntu 24.04 rootfs via debootstrap..."
    mkdir -p "$DEST"
    debootstrap \
        --variant=minbase \
        --arch=amd64 \
        "$UBUNTU_RELEASE" \
        "$DEST" \
        "$UBUNTU_MIRROR"
    echo "[ubuntu-base] Done: $DEST"
}

create_sdk() {
    local DEST="$FILES_DIR/sdk"
    if [ -d "$DEST" ]; then
        echo "[sdk] Already exists at $DEST, skipping."
        return
    fi
    local IFS=','
    local INCLUDE="${BUILD_PACKAGES[*]}"
    unset IFS
    echo "[sdk] Creating Ubuntu 24.04 SDK rootfs via debootstrap..."
    echo "[sdk] Extra packages: $INCLUDE"
    mkdir -p "$DEST"
    debootstrap \
        --variant=buildd \
        --arch=amd64 \
        --include="$INCLUDE" \
        "$UBUNTU_RELEASE" \
        "$DEST" \
        "$UBUNTU_MIRROR"
    echo "[sdk] Done: $DEST"
}

mkdir -p "$FILES_DIR"

case "$TARGET" in
    base)  create_ubuntu_base ;;
    sdk)   create_sdk ;;
    all|*) create_ubuntu_base; create_sdk ;;
esac

echo ""
echo "Done. You can now build with BuildStream:"
echo "  python3 scripts/fetch-refs.py"
echo "  bst source track elements/components/python3.bst"
echo "  bst build elements/image/system.bst"
