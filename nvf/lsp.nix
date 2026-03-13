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
    # Configure rust-analyzer to use clippy
    globals.rustaceanvim = {
      server.settings."rust-analyzer".check.command = "clippy";
    };

    # Trouble for diagnostics
    lsp.trouble.enable = true;

    # Format on save (replaces manual auto-format.lua)
    lsp.formatOnSave = true;

    # Disable NVF's default LSP keybinds (we define our own below)
    lsp.mappings = {
      hover = null;
      codeAction = null;
      format = null;
      renameSymbol = null;
      goToDefinition = null;
      goToDeclaration = null;
      goToType = null;
      listImplementations = null;
      listReferences = null;
      listDocumentSymbols = null;
      listWorkspaceSymbols = null;
      nextDiagnostic = null;
      previousDiagnostic = null;
      openDiagnosticFloat = null;
    };

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
          lsp.enable = true;
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
      (nmapLua "K" "vim.lsp.buf.hover()" "Hover docs")
      (nmapLua "<leader>ll" "vim.lsp.buf.code_action()" "Code actions")
      (nmapLua "<leader>lf" "vim.lsp.buf.format()" "Format buffer")
      (nmapLua "<leader>lR" "vim.lsp.buf.rename()" "Rename symbol")
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

    # Elixir tools plugin
    lazy.plugins."elixir-tools.nvim" = {
      package = pkgs.vimPlugins.elixir-tools-nvim;
      ft = ["elixir" "eelixir" "heex" "surface"];
      setupModule = "elixir";
      setupOpts = {
        nextls.enable = false; # Using custom LSP config
        elixirls.enable = false; # Using custom LSP config
      };
    };
    # Custom LSP configurations via luaConfigRC
    luaConfigRC.custom-lsp =
      builtins.readFile ./lua/custom-lsp.lua
      + (
        if isFullVariant
        then builtins.readFile ./lua/custom-lsp-full.lua
        else ""
      );
  };
}
