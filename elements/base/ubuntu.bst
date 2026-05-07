kind: import

description: |
  Ubuntu 24.04 (Noble Numbat) minimal base root filesystem for the runtime image.

  Created by scripts/create-sdk.sh using debootstrap --variant=minbase.
  The directory files/ubuntu-base/ must exist before building.
  Run:  make files/ubuntu-base

sources:
  - kind: local
    path: files/ubuntu-base
