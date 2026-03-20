# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Nix-managed Neovim configuration built on [NVF](https://github.com/notashelf/nvf) (Neovim Flake). NVF provides a module system for configuring Neovim declaratively via Nix. Supports multiple platforms (x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin).

## Build Commands

```bash
# Build the Neovim package
nix build

# Build and run directly
nix run

# Build specific variants
nix build .#light
nix build .#micro

# Update flake inputs
nix flake update
```

There are no tests or linters for this project itself.

Always run `nix fmt` after making edits to format the codebase with treefmt.

## Architecture

### Flake Structure

- `flake.nix`: Entry point. Uses NVF to build 3 variants (full, light, micro). Exports packages, NixOS modules, Home Manager modules, and Darwin modules.
- `plugins.nix`: Custom vim plugins not in nixpkgs (gitlinker-nvim, stay-centered-nvim, vim-mint, jj-nvim).
- `treefmt.nix`: Formatter configuration.

### NVF Modules (`nvf/`)

NVF uses a module system similar to NixOS. Each file in `nvf/` is a module that can be imported.

**Core modules:**
- `core.nix`: Shared settings imported by all variants. Sets leader keys, vim options (tabs, numbers, clipboard), colorscheme (tokyonight), universal plugins (which-key, lualine, rainbow-delimiters, mini, comment, etc.).
- `lib.nix`: Helper functions for keybindings (`nmap`, `nmapLua`, `cmd`, etc.).

**Feature modules:**
- `snacks.nix`: Snacks.nvim (dashboard, picker, terminal, indent, explorer) + `<leader>f` find keybinds + `<leader>l` LSP picker.
- `lsp.nix`: LSP servers (lua-ls, nil, nixd, elixir-ls, ts-ls, etc.) + blink.cmp completion + auto-format.
- `git.nix`: gitsigns + gitlinker + neogit + diffview + `<leader>g` keybinds.
- `navigation.nix`: oil.nvim (file explorer) + grapple (quick tags) + smart-splits (pane navigation).
- `treefmt.nix`: Treefmt integration + `<localleader>f` format keybind.
- `nix.nix`: Nix language support (nil + nixd LSP, nix treesitter).
- `neotest.nix`: Test runner + adapters + `<leader>t` keybinds.
- `claude.nix`: Claude Code integration + `<leader>c` keybinds.
- `extra-langs.nix`: Additional language support (Elixir, Unison, Mint, etc.).
- `neovide.nix`: Neovide GUI settings.

**Variant modules:**
- `full.nix`: Imports all feature modules. Daily driver config.
- `light.nix`: Imports core features only (snacks, lsp, navigation, treefmt, nix). No git, neotest, claude, extra-langs.
- `micro.nix`: Minimal config. Just snacks picker for fuzzy finding.

### How Variants Work

Each variant is built by `nvf.lib.neovimConfiguration` with different module imports:

```nix
# In flake.nix
full = mkVariant {
  inherit system;
  modules = [./nvf/core.nix ./nvf/full.nix];
  extraSpecialArgs.variant = "full";
};
```

The variant name is available as `variant` in module args and set as `vim.globals.neovim_variant` for runtime detection.

## Searching Nix Options with optnix

`optnix` is available in this repo for searching NVF, NixOS, and home-manager options. The default scope is `nvf`.

```bash
# Fuzzy search — returns similar_options when no exact match
optnix --non-interactive --json vim.git.hunk

# Exact option lookup
optnix --non-interactive --json vim.git.gitsigns.enable

# Search a different scope (nixos, home-manager)
optnix --non-interactive --json -s nixos services.nginx.enable

# List available scopes
optnix --list-scopes
```

## Adding Plugins

**IMPORTANT: Before adding ANY plugin, you MUST first search NVF's options with `optnix` to check if the plugin already has built-in support.** NVF has built-in modules for a large number of plugins. Adding a plugin manually via `extraPlugins` or `plugins.nix` when NVF already supports it is wrong — it bypasses NVF's configuration, causes conflicts, and misses out on NVF's integration. Always run `optnix --non-interactive --json vim.<category>.<plugin-name>` first. Only proceed with manual installation if optnix confirms no match exists.

### Using NVF Built-in Plugins (preferred)

NVF has built-in support for many plugins. Use `optnix` to discover available options.

Example - enabling a built-in plugin:
```nix
# In any nvf/*.nix module
config.vim = {
  git.gitsigns.enable = true;
  utility.snacks-nvim.enable = true;
  lsp.lspconfig.enable = true;
};
```

### Using Extra Plugins (not built into NVF)

**Only use this after confirming with `optnix` that NVF has no built-in support for the plugin.**

For plugins NVF doesn't have built-in support for, use `vim.extraPlugins`:

```nix
# In nvf/core.nix or feature module
config.vim = {
  extraPlugins = {
    stay-centered = {
      package = vimPlugins.stay-centered-nvim;  # From plugins.nix or nixpkgs
      setup = "require('stay-centered').setup {}";
    };
  };
};
```

### Custom Plugins (GitHub)

For plugins not in nixpkgs, add to `plugins.nix`:

```bash
# Generate fetch expression
nurl https://github.com/owner/repo.nvim
```

```nix
# plugins.nix
{pkgs}: {
  my-plugin = pkgs.vimUtils.buildVimPlugin {
    pname = "my-plugin.nvim";
    version = "YYYY-MM-DD";
    src = pkgs.fetchFromGitHub {
      owner = "owner";
      repo = "my-plugin.nvim";
      rev = "...";
      hash = "sha256-...";
    };
    meta.homepage = "https://github.com/owner/my-plugin.nvim";
  };
}
```

Then use in NVF module:
```nix
{vimPlugins, ...}: {
  config.vim.extraPlugins.my-plugin = {
    package = vimPlugins.my-plugin;
    setup = "require('my-plugin').setup {}";
  };
}
```

### Adding Keybindings

Use helpers from `lib.nix`:

```nix
{...}: let
  inherit (import ./lib.nix) nmap nmapLua cmd;
in {
  config.vim.keymaps = [
    (nmap "<leader>x" (cmd "SomeCommand") "Description")
    (nmapLua "<leader>y" "require('plugin').action()" "Description")
  ];
}
```

## Conventions

- Each feature domain gets its own module in `nvf/` (git, lsp, navigation, etc.).
- Keybindings use which-key groups for discoverability.
- Variant-specific features check `variant` arg or use conditional imports.
- Custom plugins go in `plugins.nix`, referenced via `vimPlugins` arg.
- Lua code can be inlined with `setup` strings or placed in `nvf/lua/` and loaded.
