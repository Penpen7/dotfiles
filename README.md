# dotfiles
[![ubuntu](https://github.com/Penpen7/dotfiles/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/Penpen7/dotfiles/actions/workflows/ubuntu.yml)
[![mac](https://github.com/Penpen7/dotfiles/actions/workflows/mac.yml/badge.svg)](https://github.com/Penpen7/dotfiles/actions/workflows/mac.yml)

## Description

Nix flake based dotfiles for macOS (Apple Silicon).

## Dependencies

- [Nix](https://nixos.org/download/)
- [home-manager](https://github.com/nix-community/home-manager)
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

### 3. Apply home-manager configuration

```sh
nix run home-manager/master -- switch --flake .
```

### 4. Apply nix-darwin configuration (optional)

```sh
nix run nix-darwin -- switch --flake .
```

## Update

```sh
home-manager switch --flake .
```
