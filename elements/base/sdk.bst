kind: import

description: |
  Ubuntu 24.04 (Noble Numbat) SDK: build environment used to compile Python.

  Created by scripts/create-sdk.sh using debootstrap --variant=buildd with development
  packages (build-essential, libssl-dev, libffi-dev, meson, ninja-build, etc.).
  The directory files/sdk must exist before building.
  Run:  make files/sdk

sources:
  - kind: local
    path: files/sdk
