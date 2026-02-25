# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Nix-managed Neovim configuration using **lazy.nvim** for plugin management. Plugins are installed via Nix but managed at runtime by lazy.nvim using `dir` paths to the Nix store. Supports multiple platforms (x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin).

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

### Nix Layer

- `flake.nix`: Entry point. Imports nixpkgs unstable + unison-lang flake. Exports 3 variants (full, light, micro) + custom vim plugins.
- `mkNeovim.nix`: Shared builder for full/light variants. Takes a plugin list and `luaDir`, generates `nix-plugins.lua` (maps plugin pnames to Nix store paths), bundles only lazy.nvim via Nix, and sources `lua/init.lua`.
- `mkNeovimLegacy.nix`: Legacy builder for micro variant (no lazy.nvim).
- `plugins.nix`: Defines 3 custom plugins not in nixpkgs (gitlinker-nvim, stay-centered-nvim, vim-mint).
- `variants/full.nix`: All plugins, all LSP servers, all treesitter grammars.
- `variants/light.nix`: Core plugins only, minimal closure size. No neotest, claude, git plugins, or extra LSP servers.
- `variants/micro.nix`: Smallest config — just basic editing + fuzzy finding via snacks. Uses legacy builder.

### Plugin Loading Flow (full/light variants)

```
Nix build time:
  1. mkNeovim.nix generates nix-plugins.lua: vim.g.nix_plugins = { ["plugin.pname"] = "/nix/store/..." }
  2. Only lazy.nvim is bundled in packpath
  3. lua/ directory copied to store

Neovim runtime:
  1. init.vim sources nix-plugins.lua (sets vim.g.nix_plugins)
  2. init.vim prepends lua config dir to rtp
  3. init.vim sources lua/init.lua
  4. lua/init.lua requires basic.lua (core vim settings)
  5. lua/init.lua calls lazy.setup({ spec = { import = "plugins" } })
  6. lazy.nvim loads each lua/plugins/*.lua which returns spec table(s)
  7. Each spec uses nix.spec("pname", { ... }) which sets dir = vim.g.nix_plugins["pname"]
```

### Lua Structure

- `lua/init.lua`: Entry point. Loads basic.lua, calls lazy.setup(), loads neovide.lua if GUI.
- `lua/basic.lua`: Core vim options (leader=space, 2-space tabs, relative numbers, clipboard).
- `lua/neovide.lua`: GUI-specific settings (cursor, scrolling, zoom).
- `lua/lib/nix.lua`: Helper module providing `nix.spec(pname, spec)` for building lazy specs from Nix store paths.
- `lua/micro.lua`: Self-contained micro variant config (not loaded by lazy.nvim).
- `lua/plugins/*.lua`: Each file returns a lazy.nvim spec table (or list of tables).

### Plugin Modules (`lua/plugins/`)

- `colorscheme.lua`: tokyonight (loads first, priority 1000)
- `icons.lua`: nvim-web-devicons + lspkind.nvim (lazy, loaded as dependencies)
- `which-key.lua`: which-key.nvim (VeryLazy event)
- `mini.lua`: mini.icons + mini.ai
- `luasnip.lua`: luasnip + friendly-snippets
- `trouble.lua`: trouble.nvim + `<leader>d` diagnostics keybinds
- `snacks.lua`: dashboard/picker/terminal/indent/notify + `<leader>f` find + `<leader>l` LSP picker + debug helpers + commands
- `lualine.lua`: Status bar with navic integration
- `rainbow-delimiters.lua`: Rainbow parentheses
- `git.lua`: gitsigns + gitlinker + neogit + diffview + `<leader>g` keybinds
- `oil.lua`: File explorer
- `other.lua`: Related file navigation + `<leader>o` keybinds
- `smart-splits.lua`: Pane navigation/resize/swap
- `grapple.lua`: Quick file tagging + `<leader><leader><Tab>` keybinds
- `persisted.lua`: Session management
- `comment.lua`: Code commenting
- `stay-centered.lua`: Keep cursor centered
- `neotest.lua`: Test runner + adapters + `<leader>t` keybinds (full only)
- `elixir.lua`: Elixir-specific tools
- `claude.lua`: Claude Code integration + `<leader>c` keybinds (full only)
- `treefmt.lua`: Treefmt commands + `<localleader>f` keybind (no plugin, pure Lua)
- `misc.lua`: Utility plugins + BdeleteAll/LspCapabilities commands
- `lsp.lua`: blink.cmp completion + nvim-lspconfig + LSP server configs + auto-format
- `treesitter.lua`: Treesitter highlighting/indentation

## Adding Plugins

### Step 1: Determine the Plugin pname

The plugin pname is what you'll use in Lua specs. Find it with:

```bash
nix eval nixpkgs#vimPlugins.<attr-name>.pname --raw
```

Examples:
- `nix eval nixpkgs#vimPlugins.tokyonight-nvim.pname` → `tokyonight.nvim`
- `nix eval nixpkgs#vimPlugins.blink-cmp.pname` → `blink.cmp`
- `nix eval nixpkgs#vimPlugins.nvim-treesitter.pname` → `nvim-treesitter`

**Note:** nixpkgs attribute names use dashes (`tokyonight-nvim`) but pnames often use dots (`tokyonight.nvim`). Always check the actual pname.

### Step 2: Add to Nix Variant

In `variants/full.nix` or `variants/light.nix`, add to the `plugins` list:

```nix
plugins = with pkgs.vimPlugins; [
  # Simple plugin
  my-plugin-nvim

  # Plugin needing name override (e.g., treesitter with grammars)
  {
    plugin = (nvim-treesitter.withPlugins (...));
    name = "nvim-treesitter";  # Explicit pname for Lua lookup
  }
];
```

### Step 3: Create Lua Spec

Create `lua/plugins/<name>.lua`:

```lua
local nix = require("lib.nix")
return {
  nix.spec("plugin.pname", {
    -- lazy.nvim spec options
    event = "VeryLazy",  -- or cmd, ft, keys for lazy loading
    opts = { ... },      -- passed to setup()
    -- OR for complex config:
    config = function()
      require("plugin").setup({ ... })
      -- keymaps, autocmds, etc.
    end,
    dependencies = { "other-plugin.pname" },  -- use pnames here too
  }),
}
```

### Plugin pname Reference

Common pname patterns (check with `nix eval` if unsure):

| nixpkgs attr | pname |
|--------------|-------|
| `tokyonight-nvim` | `tokyonight.nvim` |
| `blink-cmp` | `blink.cmp` |
| `mini-icons` | `mini.icons` |
| `nvim-treesitter` | `nvim-treesitter` |
| `nvim-lspconfig` | `nvim-lspconfig` |
| `friendly-snippets` | `friendly-snippets` |
| `luasnip` | `luasnip` |
| `rainbow-delimiters-nvim` | `rainbow-delimiters.nvim` |

### Variant-Specific Plugins

Plugins only in certain variants (e.g., `claudecode.nvim` in full only) automatically get disabled in other variants. The `nix.spec()` helper returns an empty table when the plugin isn't in `vim.g.nix_plugins`, which lazy.nvim ignores.

### Custom Plugins

If a plugin isn't in nixpkgs, add a derivation to `plugins.nix`:

```nix
my-plugin-nvim = pkgs.vimUtils.buildVimPlugin {
  pname = "my-plugin.nvim";  # This becomes the Lua lookup key
  version = "...";
  src = pkgs.fetchFromGitHub { ... };
};
```

Then reference it in variants as `vimPlugins.my-plugin-nvim`.

## Conventions

- Each plugin gets its own file in `lua/plugins/` returning a lazy.nvim spec.
- Tightly related plugins (e.g., gitsigns + gitlinker + neogit) can share a file, returning a list of specs.
- Keybindings use which-key for discoverability. Register groups in the plugin's config function.
- LSP servers configured with `vim.lsp.config()` and enabled with `vim.lsp.enable()` in `lsp.lua`.
- Lazy loading: prefer `event`, `cmd`, `ft`, or `keys` triggers over `lazy = false`.
- For pure Lua code without a plugin (like treefmt.lua), return `{}` and run code at file load time.
