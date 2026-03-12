---
name: optnix
description: Search Nix module system options (NVF, NixOS, home-manager, etc.)
---

# optnix — Nix Option Search

`optnix` is a CLI tool for searching Nix module system options. Use it when you need to discover or inspect NVF, NixOS, home-manager, or any configured scope's options.

## When to Use

- Finding available options for a Nix module (e.g., what options exist under `vim.languages.go`)
- Looking up option documentation (type, default, description, example)
- Discovering option names when you only know part of the name

## Available Scopes

List configured scopes:

```bash
optnix --list-scopes
```

This project has `optnix.toml` at the repo root with `nvf` as the default scope.

## Commands

### Exact Option Lookup

When you know the exact option name:

```bash
optnix --non-interactive --json <option-name>
```

Example:

```bash
optnix --non-interactive --json vim.languages.go.enable
```

Returns JSON with: `name`, `description`, `type`, `default`, `example`, `declarations`.

### Fuzzy Search

When you don't know the exact name, use a partial match:

```bash
optnix --non-interactive --json vim.languages.go.enabl
```

This exits with code 1 and returns JSON with a `similar_options` array containing close matches. Parse this to find the correct option name, then query again.

### Specifying a Scope

Override the default scope with `-s`:

```bash
optnix --non-interactive --json -s nixos services.nginx.enable
optnix --non-interactive --json -s home-manager programs.git.enable
```

Without `-s`, uses `default_scope` from `optnix.toml` (currently `nvf`).

## Workflow Examples

### 1. Discover Options Under a Path

```bash
# Fuzzy search to find all options containing "treesitter"
optnix --non-interactive --json vim.treesitter
```

Parse `similar_options` from the error response to see available options.

### 2. Get Full Option Details

```bash
# Exact lookup for complete documentation
optnix --non-interactive --json vim.treesitter.enable
```

### 3. Check Another Scope

```bash
# List available scopes first
optnix --list-scopes

# Query NixOS options
optnix --non-interactive --json -s nixos boot.loader.grub.enable
```

## Configuration

The `optnix.toml` at the repo root defines available scopes. Add new scopes there if needed.

## Flags Reference

| Flag | Description |
|------|-------------|
| `-s, --scope <name>` | Specify scope (overrides default) |
| `-n, --non-interactive` | Non-interactive mode (required for scripts) |
| `-j, --json` | JSON output (required for parsing) |
| `-l, --list-scopes` | List available scopes |
| `-m, --min-score <n>` | Minimum fuzzy match score |
| `-v, --value-only` | Output only the option value |
