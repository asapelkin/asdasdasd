kind: compose

description: |
  Minimal Ubuntu 24.04-based image containing Python and QEMU built from source.

depends:
  - ubuntu-base.bst
  - python-from-source.bst
  - qemu-from-source.bst

config:
  integrate: true
  include:
    - /usr
    - /bin
    - /sbin
    - /etc
    - /lib
    - /lib64
    - /usr/bin

