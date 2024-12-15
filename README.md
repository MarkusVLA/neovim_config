# Neovim Config

Lightweight Neovim configuration with LSP support for C and Python.

## Features

- Gruvbox theme with transparency
- LSP support (C/C++, Python)
- Auto-completion
- Auto-pairs for brackets and quotes
- Hybrid line numbers
- Minimal and clean UI

## Prerequisites

- Neovim >= 0.9.0
- Node.js and npm (for pyright LSP)
- git

## Installation

1. Install Neovim:
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
```
2. Install Packer (plugin manager):
```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
3. Clone this repo and copy configuration:
```bash
git clone git@github.com:MarkusVLA/neovim_config.git
mkdir -p ~/.config/nvim
cp -r dotfiles/nvim/* ~/.config/nvim/
```
4. Install plugins in Neovim:
```
:PackerSync
```
5. Install language servers through Mason:
```
:Mason
```
