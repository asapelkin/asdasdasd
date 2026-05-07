# Ubuntu Mini POC (BuildStream)

Pre-POC repository that uses **BuildStream** as the orchestrator to assemble a minimal Ubuntu 24.04-based root filesystem with:

- Ubuntu 24.04 base rootfs
- Python built from source
- QEMU built from source

## Build locally

```bash
pip install buildstream
bst build image.bst
bst artifact checkout image.bst --directory out/rootfs
```

Create a tarball:

```bash
tar -C out -czf ubuntu-mini-poc-rootfs.tar.gz rootfs
```

## CI/CD

Workflow: `.github/workflows/build-and-release.yml`

- Manual run via `workflow_dispatch`
- Automatic run on tags `v*`
- Uploads `ubuntu-mini-poc-rootfs.tar.gz` as action artifact
- On tags, publishes asset to GitHub Releases

## Notes

This is intentionally minimal and may require iteration for full reproducibility and build dependencies inside BuildStream sandboxes.
