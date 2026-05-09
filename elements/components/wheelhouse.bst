kind: import

description: |
  Python package source wheelhouse staged from PyPI with BuildStream.

  Tracks and fetches pytest, click, tabulate, numpy, and all transitively
  resolved Python package source distributions using the buildstream-plugins
  pip source.

sources:
  - kind: local
    path: requirements/wheelhouse.txt
  - kind: pip
    url: "pypi:"
    requirements-files:
      - wheelhouse.txt

config:
  source: .bst_pip_downloads
  target: /wheelhouse
