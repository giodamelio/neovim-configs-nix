# neovim-configs-nix

Nix-managed Neovim configuration with modular Lua architecture and 80+ plugins.

## Variants

| Variant | Description | Use Case |
|---------|-------------|----------|
| `full` (default) | All plugins, LSP servers, and treesitter grammars | Daily driver |
| `light` | Core plugins only, minimal closure | Servers, containers |
| `micro` | Basic editing + fuzzy finding | Quick edits, minimal footprint |

## Usage

Run directly without installing:

```bash
nix run github:giodamelio/neovim-configs-nix
nix run github:giodamelio/neovim-configs-nix#light
nix run github:giodamelio/neovim-configs-nix#micro
```

Or build locally:

```bash
nix build
./result/bin/nvim
```

## Platforms

- x86_64-linux
- aarch64-linux
- x86_64-darwin
- aarch64-darwin

## Structure

```
flake.nix          # Entry point, variant exports
mkNeovim.nix       # Shared builder function
plugins.nix        # Custom plugins not in nixpkgs
variants/          # Variant definitions (full, light, micro)
lua/               # Lua configuration modules
  basic.lua        # Core vim options
  lsp.lua          # LSP and completion setup
  treesitter.lua   # Treesitter configuration
  plugins/         # Per-plugin configuration files
```

## License

MIT
