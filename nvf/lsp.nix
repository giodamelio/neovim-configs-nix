# LSP, completion, diagnostics, and language configuration.
{
  pkgs,
  lib,
  variant ? "full",
  ...
}: let
  inherit (import ./lib.nix) cmd nmap nmapLua snacksPicker;
  isFullVariant = variant == "full";
in {
  config.vim = {
    # Trouble for pretty diagnostic lists
    lsp.trouble.enable = true;

    # Autocomplete with blink.cmp
    autocomplete.blink-cmp = {
      enable = true;
      setupOpts = {
        keymap.preset = "default";
        appearance.nerd_font_variant = "mono";
        completion = {
          documentation.auto_show = false;
        };
        signature.enabled = true;
        fuzzy.implementation = "prefer_rust_with_warning";
      };
    };

    # Snippets
    snippets.luasnip.enable = true;

    # LSP kind icons for blink-cmp
    startPlugins = with pkgs.vimPlugins; [lspkind-nvim];

    # NVF Language modules
    languages =
      {
        # Nix
        nix = {
          enable = true;
          lsp = {
            enable = true;
            servers = ["nil"];
          };
          format = {
            enable = true;
            type = ["alejandra"];
          };
        };

        # Lua
        lua = {
          enable = true;
          lsp.enable = true;
        };

        # Python
        python = {
          enable = true;
          lsp = {
            enable = true;
            servers = ["basedpyright"];
          };
          format = {
            enable = true;
            type = ["ruff"];
          };
        };

        # Rust (uses rustaceanvim under the hood)
        rust = {
          enable = true;
          lsp = {
            enable = true;
            # Configure rust-analyzer to use clippy via luaConfigRC
          };
        };

        # Go
        go = {
          enable = true;
          lsp.enable = true;
        };

        # TypeScript/JavaScript
        ts = {
          enable = true;
          lsp.enable = true;
        };

        # HTML with emmet
        html = {
          enable = true;
          lsp.enable = true;
        };

        # CSS
        css = {
          enable = true;
          lsp.enable = true;
        };

        # Elixir
        elixir = {
          enable = true;
          lsp.enable = true;
        };
      }
      // lib.optionalAttrs isFullVariant {
        # Haskell (full only)
        haskell = {
          enable = true;
          lsp.enable = true;
        };
      };

    # Keymaps
    keymaps = [
      # === LSP ===
      (nmapLua "K" "vim.lsp.buf.hover()" "Show hover docs")
      (nmapLua "<leader>ll" "vim.lsp.buf.code_action()" "Show code actions")
      (nmapLua "<leader>lf" "vim.lsp.buf.format()" "Format buffer")
      (nmapLua "<leader>lR" "vim.lsp.buf.rename()" "Rename under cursor")

      # === Trouble Diagnostics ===
      (nmap "<leader>dd" (cmd "Trouble diagnostics toggle") "Document diagnostics")
      (nmap "<leader>dl" (cmd "Trouble lsp toggle") "LSP toggle")
      (nmap "<leader>de" (cmd "Trouble lsp_definitions toggle") "Definitions")
      (nmap "<leader>di" (cmd "Trouble lsp_implementations toggle") "Implementations")
      (nmap "<leader>dr" (cmd "Trouble lsp_references toggle") "References")
      (
        nmapLua "<leader>dn" "require('trouble').next({ skip_groups = true, jump = true })"
        "Next diagnostic"
      )
      (
        nmapLua "<leader>dp" "require('trouble').prev({ skip_groups = true, jump = true })"
        "Previous diagnostic"
      )

      # === Snacks Picker: LSP ===
      (nmapLua "<leader>lD" (snacksPicker "lsp_definitions") "Show definitions")
      (nmapLua "<leader>ld" (snacksPicker "lsp_declarations") "Show declarations")
      (nmapLua "<leader>li" (snacksPicker "lsp_implementations") "Show implementations")
      (nmapLua "<leader>ls" (snacksPicker "lsp_symbols") "Show buffer symbols")
      (nmapLua "<leader>lS" (snacksPicker "lsp_workspace_symbols") "Show workspace symbols")
      (nmapLua "<leader>lr" (snacksPicker "lsp_references") "Show references")
      (nmapLua "<leader>lt" (snacksPicker "lsp_type_definitions") "Show type definition")
    ];

    # Custom LSP configurations via luaConfigRC
    luaConfigRC.custom-lsp =
      builtins.readFile ./lua/custom-lsp.lua
      + (
        if isFullVariant
        then builtins.readFile ./lua/custom-lsp-full.lua
        else ""
      );

    # Auto-format on save
    luaConfigRC.auto-format = builtins.readFile ./lua/auto-format.lua;
  };
}
