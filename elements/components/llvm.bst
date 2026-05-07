kind: cmake

description: |
  LLVM toolchain built from source using CMake.

  Source: https://github.com/llvm/llvm-project, tag llvmorg-18.1.8
  The git ref is stored in project.refs and updated by:
    bst source track components/llvm.bst

  Installs to /usr inside the element artifact.

build-depends:
  - base/sdk.bst

sources:
  - kind: git
    url: github:llvm/llvm-project.git
    track: llvmorg-18.1.8

variables:
  conf-root: "%{build-root}/llvm"
  cmake-local: |
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_ASSERTIONS=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_TARGETS_TO_BUILD=X86
