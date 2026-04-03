#!/bin/sh
# Install runlicense CLI
# Usage: curl -fsSL https://raw.githubusercontent.com/runlicense/runlicense/main/install.sh | sh
set -eu

REPO="runlicense/runlicense"
BINARY="runlicense"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

info() { printf '\033[1;34m%s\033[0m\n' "$*"; }
error() { printf '\033[1;31merror: %s\033[0m\n' "$*" >&2; exit 1; }

detect_target() {
    os=$(uname -s)
    arch=$(uname -m)

    case "$os" in
        Darwin) os_part="apple-darwin" ;;
        Linux)  os_part="unknown-linux-gnu" ;;
        *)      error "Unsupported OS: $os. Download manually from https://github.com/$REPO/releases" ;;
    esac

    case "$arch" in
        x86_64|amd64)  arch_part="x86_64" ;;
        arm64|aarch64) arch_part="aarch64" ;;
        *)             error "Unsupported architecture: $arch" ;;
    esac

    echo "${arch_part}-${os_part}"
}

get_latest_version() {
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/'
    elif command -v wget >/dev/null 2>&1; then
        wget -qO- "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/'
    else
        error "curl or wget is required"
    fi
}

download() {
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL -o "$2" "$1"
    else
        wget -qO "$2" "$1"
    fi
}

main() {
    target=$(detect_target)
    version=$(get_latest_version)
    artifact="${BINARY}-${target}.tar.gz"
    url="https://github.com/$REPO/releases/download/$version/$artifact"

    info "Installing $BINARY $version ($target)"

    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' EXIT

    info "Downloading $url"
    download "$url" "$tmpdir/$artifact"

    tar xzf "$tmpdir/$artifact" -C "$tmpdir"

    if [ -w "$INSTALL_DIR" ]; then
        mv "$tmpdir/$BINARY" "$INSTALL_DIR/$BINARY"
    else
        info "Elevated permissions required to install to $INSTALL_DIR"
        sudo mv "$tmpdir/$BINARY" "$INSTALL_DIR/$BINARY"
    fi

    chmod +x "$INSTALL_DIR/$BINARY"

    info "Installed $BINARY to $INSTALL_DIR/$BINARY"
    info "Run '$BINARY --help' to get started"
}

main
