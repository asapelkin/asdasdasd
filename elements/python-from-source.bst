kind: manual

description: Build CPython from source and install into /usr.

depends:
  - ubuntu-base.bst

sources:
  - kind: tar
    url: https://www.python.org/ftp/python/3.12.4/Python-3.12.4.tgz
    ref: ff3f2fcbfd79a4dcf2f5d82f1cd4f7db06b4f19a7a46c90dbf3ba8fd5e0f7f76

config:
  configure-commands:
    - ./configure --prefix=/usr --enable-optimizations
  build-commands:
    - make -j"$(nproc)"
  install-commands:
    - make DESTDIR="%{install-root}" install

