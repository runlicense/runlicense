# RunLicense

The RunLicense CLI tool, installable for your platform.

## Quick Install

### macOS / Linux

```sh
curl -fsSL https://raw.githubusercontent.com/runlicense/runlicense/main/install.sh | sh
```

This auto-detects your platform and installs the latest version.

### Windows

1. Download [runlicense-x86_64-pc-windows-msvc.zip](https://github.com/runlicense/runlicense/releases/latest/download/runlicense-x86_64-pc-windows-msvc.zip)
2. Extract `runlicense.exe`
3. Move it to a directory in your `PATH`

### Verify installation

```sh
runlicense --help
```

## Usage

### Authentication

```sh
runlicense auth login    # Log in (opens browser)
runlicense auth logout   # Log out and remove stored credentials
runlicense auth status   # Show current authentication status
```

On first run, `runlicense` will automatically open your browser to log in.

### Help

```sh
runlicense --help        # Show all available commands
runlicense auth --help   # Show auth subcommands
```

## Updating

To update, re-run the install command. It always fetches the latest release.

## Manual Download

Pre-built binaries for all platforms are available on the [Releases](https://github.com/runlicense/runlicense/releases) page.
