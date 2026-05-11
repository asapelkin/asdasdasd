# Makefile – convenience targets for working with the minimal-linux project
.PHONY: all prereqs sandbox ownership sources build checkout clean help

help:
	@echo "Targets:"
	@echo "  make all            - Build and check out the image (default)"
	@echo "  make prereqs        - Install local build prerequisites if missing"
	@echo "  make files/ubuntu-base  - Create Ubuntu 24.04 minimal rootfs (needs sudo)"
	@echo "  make files/sdk      - Create Ubuntu 24.04 SDK with build tools (needs sudo)"
	@echo "  make sources        - Compute/track all source refs"
	@echo "  make build          - Build the system image with BuildStream"
	@echo "  make checkout       - Export assembled image to output/"
	@echo "  make wheelhouse     - Build and check out the Python package wheelhouse"
	@echo "  make clean          - Remove generated files (does NOT remove files/)"

# ── Prerequisites ────────────────────────────────────────────────────────────

prereqs:
	@missing_apt=""; \
	if ! command -v debootstrap >/dev/null 2>&1; then missing_apt="$$missing_apt debootstrap"; fi; \
	if ! command -v bwrap >/dev/null 2>&1; then missing_apt="$$missing_apt bubblewrap"; fi; \
	if [ -n "$$missing_apt" ]; then \
		echo "Installing apt prerequisites:$$missing_apt"; \
		sudo apt-get update -qq; \
		sudo apt-get install -y --no-install-recommends $$missing_apt; \
	fi
	@python3 -c "import buildstream, ruamel.yaml, buildstream_plugins" >/dev/null 2>&1 || python3 -m pip install -r requirements.txt

sandbox:
	@if sysctl -n kernel.apparmor_restrict_unprivileged_userns >/dev/null 2>&1; then \
		if [ "$$(sysctl -n kernel.apparmor_restrict_unprivileged_userns)" != "0" ]; then \
			echo "Allowing unprivileged user namespaces for BuildStream sandbox..."; \
			sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0; \
		fi; \
	fi

files/ubuntu-base: prereqs
	@echo "Creating Ubuntu 24.04 minimal base rootfs (requires debootstrap + sudo)..."
	sudo bash scripts/create-sdk.sh base

files/sdk: prereqs
	@echo "Creating Ubuntu 24.04 SDK rootfs (requires debootstrap + sudo)..."
	sudo bash scripts/create-sdk.sh sdk

ownership: files/ubuntu-base files/sdk
	@echo "Fixing ownership of generated files/ tree..."
	sudo chown -R "$$(id -un):$$(id -gn)" files/

# ── Source refs ──────────────────────────────────────────────────────────────

sources: prereqs sandbox ownership
	bst source track components/python3.bst components/llvm.bst components/wheelhouse.bst

# ── Build ─────────────────────────────────────────────────────────────────────

build: prereqs sandbox ownership
	bst build image/system.bst

wheelhouse: prereqs sandbox
	rm -rf output/wheelhouse
	mkdir -p output/wheelhouse
	bst build components/wheelhouse.bst
	bst artifact checkout components/wheelhouse.bst --directory output/wheelhouse/

# ── Checkout ─────────────────────────────────────────────────────────────────

checkout: build
	rm -rf output
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
