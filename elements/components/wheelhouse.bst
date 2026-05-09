kind: manual

description: |
  Python package source wheelhouse staged from PyPI with BuildStream.

  Tracks and fetches pytest, click, tabulate, numpy, and all transitively
  resolved Python package source distributions using the buildstream-plugins
  pip source.

sources:
  - kind: pip
    packages:
      - pytest
      - click
      - tabulate
      - numpy

config:
  install-commands:
    - mkdir -p "%{install-root}/wheelhouse"
    - cp -a .bst_pip_downloads/. "%{install-root}/wheelhouse/"
