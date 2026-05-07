kind: autotools

description: |
  QEMU 9.0 machine emulator and virtualizer built from source.

  Source: https://download.qemu.org/qemu-9.0.0.tar.xz
  The sha256 ref is stored in project.refs and updated by:
    python3 scripts/fetch-refs.py

  QEMU uses Meson internally (via its ./configure Python wrapper).
  We override configure-commands so only QEMU-compatible flags are passed.

  Targets built:
    - x86_64-softmmu    (full system emulation, KVM-capable)
    - x86_64-linux-user (Linux user-mode emulation)

  Installs to /usr inside the element artifact.

build-depends:
  - base/sdk.bst

sources:
  - kind: tar
    url: qemu-dl:qemu-9.0.0.tar.xz
    # ref is stored in project.refs and updated by scripts/fetch-refs.py

config:
  # Override configure to use only QEMU-accepted options
  # (QEMU's ./configure is a Python wrapper that calls meson internally)
  configure-commands:
    - |
      ./configure \
          --prefix=/usr \
          --target-list=x86_64-softmmu,x86_64-linux-user \
          --enable-kvm \
          --disable-docs \
          --disable-gtk \
          --disable-sdl \
          --disable-opengl \
          --disable-werror
