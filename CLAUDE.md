# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Nix-managed Neovim configuration with modular Lua architecture and 80+ plugins. Supports multiple platforms (x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin).

## Build Commands

```bash
# Build the Neovim package
nix build

# Build and run directly
nix run

# Update flake inputs
nix flake update
```

There are no tests or linters for this project itself.

## Architecture

**Nix layer** (`flake.nix` → `package.nix` → `plugins.nix`):
- `flake.nix`: Entry point. Imports nixpkgs unstable + unison-lang flake. Exports custom vim plugins.
- `package.nix`: Builds the Neovim package using `neovimUtils.makeNeovimConfig`. Wraps with runtime dependencies (imagemagick, netcat-gnu). Defines the full plugin list and embeds Lua config via `customRC`.
- `plugins.nix`: Defines 4 custom plugins not in nixpkgs (gitlinker-nvim, stay-centered-nvim, tree-sitter-surrealdb, vim-mint).

**Lua modules** are loaded in a strict order defined in `package.nix`:
`basic` → `lsp` → `treesitter` → `plugins` → `commands` → `keybinds` → `neovide`

This order matters — later modules depend on earlier ones (e.g., keybinds reference plugin APIs set up in `plugins.lua`).

**Key module responsibilities:**
- `basic.lua`: Core vim options (leader=space, 2-space tabs, relative numbers, clipboard)
- `lsp.lua`: blink.cmp completion setup + 12 language server configs + auto-format on save
- `plugins.lua`: Configuration for 30+ plugins (oil, neotest, gitsigns, neogit, avante, snacks, etc.)
- `keybinds.lua`: All keybindings via which-key. Organized by prefix: `<leader>f` (find), `<leader>d` (diagnostics), `<leader>t` (test), `<leader>l` (LSP), `<leader>g` (git), `<leader>c` (Claude)
- `commands.lua`: 13 custom user commands (BdeleteAll, Treefmt, NixInstall, etc.)
- `treesitter.lua`: Treesitter highlighting/indentation + custom SurrealDB grammar
- `neovide.lua`: GUI-specific settings (cursor, scrolling, zoom)

## Adding Plugins

1. Check if the plugin exists in nixpkgs. If not, add a derivation in `plugins.nix`.
2. Add the plugin to the `plugins` list in `package.nix`.
3. Add plugin configuration in `lua/plugins.lua`.
4. Add any keybindings in `lua/keybinds.lua` using `wk.add()`.

## Conventions

- All keybindings use which-key (`wk.add()`) for discoverability and grouping.
- LSP servers are configured with `vim.lsp.config()` and enabled with `vim.lsp.enable()`.
- Plugin configs in `plugins.lua` follow the pattern: require the plugin, call setup with options.
- `other-nvim` mappings define related-file patterns per project type (Rails, Go, Elixir/Phoenix, TypeScript).
