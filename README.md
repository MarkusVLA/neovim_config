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

1. Install Packer (plugin manager):
```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
2. Clone this repo and copy configuration:
```bash
git clone git@github.com:MarkusVLA/neovim_config.git
mkdir -p ~/.config/nvim
cp -r neovim_config/* ~/.config/nvim/
```
3. Install plugins in Neovim:
```
:PackerSync
```
4. Install language servers through Mason
```
:Mason
```
