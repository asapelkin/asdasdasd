kind: import

description: |
  Ubuntu 24.04 (Noble Numbat) SDK: build environment used to compile Python and QEMU.

  Created by scripts/create-sdk.sh using debootstrap --variant=buildd with development
  packages (build-essential, libssl-dev, libglib2.0-dev, meson, ninja-build, etc.).
  The directory files/sdk must exist before building.
  Run:  make files/sdk

sources:
  - kind: local
    path: files/sdk
