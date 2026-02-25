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

# Build specific variants
nix build .#light
nix build .#micro

# Update flake inputs
nix flake update
```

There are no tests or linters for this project itself.

Always run `nix fmt` after making edits to format the codebase with treefmt.

## Architecture

**Nix layer** (`flake.nix` → `mkNeovim.nix` → `plugins.nix`):
- `flake.nix`: Entry point. Imports nixpkgs unstable + unison-lang flake. Exports 3 variants (full, light, micro) + custom vim plugins.
- `mkNeovim.nix`: Shared builder function. Takes a plugin list and `luaModules` list, generates `customRC` with ordered `luafile` commands, wraps with runtime dependencies.
- `plugins.nix`: Defines 3 custom plugins not in nixpkgs (gitlinker-nvim, stay-centered-nvim, vim-mint).
- `variants/full.nix`: All plugins, all LSP servers, all treesitter grammars.
- `variants/light.nix`: Core plugins only, minimal closure size. No neotest, claude, or extra LSP servers.
- `variants/micro.nix`: Smallest config — just basic editing + fuzzy finding via snacks.

**Lua modules** follow a per-plugin architecture. Each plugin (or tight group of related plugins) gets its own file containing setup, keybindings, and commands together. Load order is controlled by the `luaModules` list in each variant's nix file.

**Core modules** (not plugin-specific):
- `basic.lua`: Core vim options (leader=space, 2-space tabs, relative numbers, clipboard). Must load first.
- `lsp.lua`: blink.cmp completion setup + 12 language server configs + auto-format on save + pure vim.lsp keybinds (`K`, `<leader>ll`, `<leader>lf`, `<leader>lR`).
- `lsp-extra.lua`: Niche LSP servers (haskell, unison, sourcekit). Full variant only.
- `treesitter.lua`: Treesitter highlighting/indentation via built-in vim.treesitter API.
- `neovide.lua`: GUI-specific settings (cursor, scrolling, zoom). Loads last.

**Plugin modules** (`lua/plugins/`):
- `mini.lua`: mini.icons + mini.ai setup.
- `luasnip.lua`: Snippet lazy loading from vscode format.
- `trouble.lua`: Trouble setup + `<leader>d` diagnostics keybinds. Must load before snacks.
- `snacks.lua`: Snacks setup (dashboard, picker, terminal, indent, notify) + `<leader>f` find keybinds + `<leader>l` LSP picker keybinds + terminal/explorer keybinds + debug helpers + commands (FilesHidden, LuaDebugRun, LuaEval, Dashboard, NixInstall).
- `lualine.lua`: Status bar setup with navic integration.
- `rainbow-delimiters.lua`: Rainbow parentheses highlighting.
- `git.lua`: gitsigns + gitlinker + neogit setup + all `<leader>g` keybinds.
- `oil.lua`: Oil file explorer setup.
- `other.lua`: other-nvim related file navigation + `<leader>o` keybinds.
- `smart-splits.lua`: Pane navigation (`C-hjkl`), resize (`A-hjkl`), buffer swap (`<leader><leader>hjkl`).
- `grapple.lua`: Quick file tagging + `<leader><leader><Tab>` keybinds.
- `persisted.lua`: Session management.
- `comment.lua`: Code commenting.
- `stay-centered.lua`: Keep cursor centered.
- `neotest.lua`: Test runner + adapters + `<leader>t` keybinds. Full variant only.
- `elixir.lua`: Elixir-specific tools.
- `claude.lua`: Claude Code integration + `<leader>c` keybinds. Full variant only.
- `treefmt.lua`: Treefmt/TreefmtAll commands + `<localleader>f` keybind.
- `misc.lua`: Standalone commands (BdeleteAll, LspCapabilities) + `<leader><Tab>` switch buffer.
- `micro.lua`: Self-contained micro variant config (mini snacks setup + basic keybinds).

**Load order constraint:** `trouble.lua` must load before `snacks.lua` because snacks picker config references `trouble.sources.snacks` at setup time.

## Adding Plugins

1. Check if the plugin exists in nixpkgs. If not, add a derivation in `plugins.nix`.
2. Add the plugin to the `plugins` list in the relevant variant file(s) (`variants/*.nix`).
3. Create a new file `lua/plugins/<plugin-name>.lua` with the plugin setup, keybindings, and any related commands.
4. Add the new lua file to the `luaModules` list in the relevant variant file(s), respecting load order.

## Conventions

- Each plugin gets its own file in `lua/plugins/` containing setup + keybinds + commands. Tightly related plugins (e.g., gitsigns + gitlinker + neogit) can share a file.
- All keybindings use which-key (`require("which-key").add()`) for discoverability. Each plugin file registers its own which-key group(s).
- LSP servers are configured with `vim.lsp.config()` and enabled with `vim.lsp.enable()`.
- Variants compose by selecting which lua files to include in `luaModules`. To exclude a plugin from a variant, simply omit its lua file and nix plugin entry.
- `other-nvim` mappings define related-file patterns per project type (Rails, Go, Elixir/Phoenix, TypeScript).
