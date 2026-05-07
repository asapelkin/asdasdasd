kind: manual

description: Build QEMU from source and install into /usr.

depends:
  - ubuntu-base.bst

sources:
  - kind: tar
    url: https://download.qemu.org/qemu-9.0.2.tar.xz
    ref: 8790ac78496cae2d6452c4652f0475422f3f06609bf8cb3bfda63b4fd1ce0c42

config:
  configure-commands:
    - ./configure --prefix=/usr --target-list=x86_64-softmmu --disable-werror
  build-commands:
    - make -j"$(nproc)"
  install-commands:
    - make DESTDIR="%{install-root}" install

