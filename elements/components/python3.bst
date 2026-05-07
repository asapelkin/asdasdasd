kind: autotools

description: |
  CPython 3.12 interpreter built from source using GNU autotools.

  Source: https://github.com/python/cpython, tag v3.12.3
  The git ref is stored in project.refs and updated by:
    bst source track components/python3.bst

  Installs to /usr inside the element artifact.

build-depends:
  - base/sdk.bst

sources:
  - kind: git
    url: github:python/cpython.git
    track: v3.12.3

variables:
  # Extra configure flags specific to CPython
  conf-local: |
    --enable-optimizations
    --with-lto
    --with-ensurepip=install
    --without-static-libpython
    --with-system-expat
    --with-system-ffi

# GitHub Actions runners block RTM_NEWADDR in new network namespaces.
# Share the host network namespace so bwrap skips loopback setup.
sandbox:
  network-access: true
