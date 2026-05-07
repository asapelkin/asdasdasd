kind: stack

description: |
  Minimal Linux system image based on Ubuntu 24.04 (Noble Numbat).

  Composition:
    - base/ubuntu  : Ubuntu 24.04 minimal root filesystem (runtime)
    - components/python3 : CPython 3.12 interpreter (built from source)
    - components/llvm : LLVM toolchain (built from source)

  To check out the assembled image:
    bst artifact checkout image/system.bst --directory output/

depends:
  - base/ubuntu.bst
  - components/python3.bst
  - components/llvm.bst
