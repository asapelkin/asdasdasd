#!/usr/bin/env python3
"""
fetch-refs.py – Download the QEMU release tarball, compute its SHA-256, and
write the ref into project.refs so that BuildStream can verify the source.

Usage:
    python3 scripts/fetch-refs.py

After running this script, also run:
    bst source track elements/components/python3.bst
to populate the git ref for CPython.
"""

import hashlib
import os
import sys
import urllib.request

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
PROJECT_REFS = os.path.join(PROJECT_ROOT, "project.refs")

# QEMU 9.0.0 tarball
QEMU_URL = "https://download.qemu.org/qemu-9.0.0.tar.xz"
QEMU_ELEMENT = "components/qemu.bst"


def sha256_of_url(url: str) -> str:
    """Download *url* and return the hex SHA-256 digest (streaming, no temp file)."""
    print(f"  Fetching {url} …", flush=True)
    h = hashlib.sha256()
    req = urllib.request.Request(url, headers={"User-Agent": "fetch-refs/1.0"})
    with urllib.request.urlopen(req) as resp:
        while True:
            chunk = resp.read(1 << 20)  # 1 MiB chunks
            if not chunk:
                break
            h.update(chunk)
    return h.hexdigest()


def read_project_refs(path: str) -> str:
    if os.path.exists(path):
        with open(path) as fh:
            return fh.read()
    return "projects:\n  minimal-linux: {}\n"


def update_project_refs(path: str, element: str, sha: str) -> None:
    """
    Update project.refs YAML by inserting or replacing the ref for *element*.

    We do a targeted text manipulation rather than a full YAML round-trip so
    that comments and formatting are preserved as much as possible.
    """
    try:
        import ruamel.yaml

        ry = ruamel.yaml.YAML()
        ry.preserve_quotes = True
        with open(path) as fh:
            data = ry.load(fh)
        if not data:
            data = {}
        if "projects" not in data:
            data["projects"] = {}
        if "minimal-linux" not in data["projects"] or data["projects"]["minimal-linux"] is None:
            data["projects"]["minimal-linux"] = {}
        data["projects"]["minimal-linux"][element] = [{"sha": sha}]
        with open(path, "w") as fh:
            ry.dump(data, fh)
    except ImportError:
        # Fallback: simple string replacement / append
        content = read_project_refs(path)
        # Write a new file if the element is already present
        lines = content.splitlines(keepends=True)
        new_lines = []
        skip = False
        found = False
        for line in lines:
            if line.strip().startswith(f"{element}:"):
                found = True
                skip = True
                new_lines.append(f"  {element}:\n")
                new_lines.append(f"  - sha: {sha}\n")
                continue
            if skip and line.startswith("  ") and not line.startswith("    "):
                skip = False
            if not skip:
                new_lines.append(line)
        if not found:
            # Append under minimal-linux
            out = []
            for line in new_lines:
                out.append(line)
                if "minimal-linux:" in line:
                    out.append(f"  {element}:\n")
                    out.append(f"  - sha: {sha}\n")
            new_lines = out
        with open(path, "w") as fh:
            fh.writelines(new_lines)


def main() -> None:
    print("Fetching QEMU 9.0.0 tarball ref …")
    sha = sha256_of_url(QEMU_URL)
    print(f"  sha256 = {sha}")

    update_project_refs(PROJECT_REFS, QEMU_ELEMENT, sha)
    print(f"\nWrote ref for {QEMU_ELEMENT} to {PROJECT_REFS}")

    print("\nNext step:")
    print("  bst source track elements/components/python3.bst")


if __name__ == "__main__":
    main()
