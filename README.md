# neovim-configs-nix

Nix-managed Neovim configuration built on [NVF](https://github.com/notashelf/nvf).

## Variants

| Variant | Description | Use Case |
|---------|-------------|----------|
| `default` (full) | All plugins, LSP servers, and treesitter grammars | Daily driver |
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

## NixOS / Home Manager / Darwin Integration

Import the modules directly in your system configuration:

```nix
# flake.nix inputs
inputs.neovim-configs.url = "github:giodamelio/neovim-configs-nix";

# NixOS module
{ inputs, ... }: {
  imports = [ inputs.neovim-configs.nixosModules.${system}.full ];
}

# Home Manager module
{ inputs, ... }: {
  imports = [ inputs.neovim-configs.homeManagerModules.${system}.full ];
}

# Darwin module
{ inputs, ... }: {
  imports = [ inputs.neovim-configs.darwinModules.${system}.full ];
}
```

## Platforms

- x86_64-linux
- aarch64-linux
- x86_64-darwin
- aarch64-darwin

## License

MIT
