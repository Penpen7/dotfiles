# dotfiles

## Description

Nix flake based dotfiles for macOS (Apple Silicon).

## Dependencies

- [Nix](https://nixos.org/download/)
- [nix-darwin](https://github.com/LnL7/nix-darwin)

## Getting Started

### 1. Install Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Clone this repository

```sh
git clone https://github.com/Penpen7/dotfiles ~/dotfiles
cd ~/dotfiles
```

### 3. Apply configuration

```sh
nix run nix-darwin -- switch --flake .#work
```

## Update

```sh
sudo darwin-rebuild switch --flake .#work
```

## Manually Managed Apps

The following apps cannot be managed by nix / brew cask / mas and require manual installation.

| App | Reason | Install From |
|-----|--------|--------------|
| Cisco Packet Tracer | Requires Cisco NetAcad account; not available via brew/mas | [Cisco NetAcad](https://www.netacad.com/resources/lab-downloads) |
| CuboAi | iOS-only app; cannot be installed via mas | [App Store](https://apps.apple.com/jp/app/cuboai-%E3%83%99%E3%83%93%E3%83%BC%E3%83%A2%E3%83%8B%E3%82%BF%E3%83%BC/id1329291822) |
| Pioneer (DDJ-RB, FwUpdateManager, XDJ-XZ) | Device-specific utilities for Pioneer DJ hardware; not available via brew/mas | [AlphaTheta Support](https://support.alphatheta.com/en-US/sections/4) |
| Traxsource Downloader | Distributed exclusively via Traxsource; not available via brew/mas | [Traxsource Downloader](https://downloader.traxsource.com/) |
