# Makefile – convenience targets for working with the minimal-linux project
.PHONY: all sources build checkout clean help

help:
	@echo "Targets:"
	@echo "  make all            - Build and check out the image (default)"
	@echo "  make files/ubuntu-base  - Create Ubuntu 24.04 minimal rootfs (needs sudo)"
	@echo "  make files/sdk      - Create Ubuntu 24.04 SDK with build tools (needs sudo)"
	@echo "  make sources        - Compute/track all source refs"
	@echo "  make build          - Build the system image with BuildStream"
	@echo "  make checkout       - Export assembled image to output/"
	@echo "  make clean          - Remove generated files (does NOT remove files/)"

# ── Prerequisites ────────────────────────────────────────────────────────────

files/ubuntu-base:
	@echo "Creating Ubuntu 24.04 minimal base rootfs (requires debootstrap + sudo)..."
	sudo bash scripts/create-sdk.sh base

files/sdk:
	@echo "Creating Ubuntu 24.04 SDK rootfs (requires debootstrap + sudo)..."
	sudo bash scripts/create-sdk.sh sdk

# ── Source refs ──────────────────────────────────────────────────────────────

sources: files/ubuntu-base files/sdk
	python3 scripts/fetch-refs.py
	bst source track components/python3.bst

# ── Build ─────────────────────────────────────────────────────────────────────

build: files/ubuntu-base files/sdk
	bst build image/system.bst

# ── Checkout ─────────────────────────────────────────────────────────────────

checkout: build
	mkdir -p output
	bst artifact checkout image/system.bst --directory output/
	@echo "Image checked out to output/"

# ── All ──────────────────────────────────────────────────────────────────────

all: checkout

# ── Clean ────────────────────────────────────────────────────────────────────

clean:
	rm -rf output/ minimal-linux*.tar.gz
	@echo "Cleaned output artifacts."
	@echo "NOTE: files/ubuntu-base and files/sdk are preserved."
	@echo "      Remove them manually with: sudo rm -rf files/"
