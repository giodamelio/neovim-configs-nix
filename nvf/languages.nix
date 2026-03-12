# Language and LSP configuration.
# Uses NVF language modules where available, custom LSP config for others.
{
  lib,
  variant ? "full",
  ...
}: let
  isFullVariant = variant == "full";
in {
  config.vim = {
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

    # Custom LSP configurations via luaConfigRC
    luaConfigRC.custom-lsp = ''
      -- Custom LSP server configurations

      -- Expert LSP for Elixir
      vim.lsp.config("expert", {
        cmd = { "expert", "--stdio" },
        root_markers = { "mix.exs" },
        filetypes = { "elixir", "eelixir", "heex", "surface" },
      })

      -- Emmet for additional filetypes
      vim.lsp.config("emmet_ls", {
        filetypes = { "css", "html", "javascript", "heex", "htmldjango" },
      })

      -- Lexical LSP for Elixir
      vim.lsp.config("lexical", {
        cmd = { "lexical" },
      })

      -- Configure rust-analyzer to use clippy
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
            },
          },
        },
      })

      -- Enable custom LSP servers
      vim.lsp.enable("nixd")
      vim.lsp.enable("expert")
      vim.lsp.enable("nextls")
      vim.lsp.enable("emmet_ls")
      vim.lsp.enable("lexical")
      ${
        if isFullVariant
        then ''
          -- Full variant extras
          vim.lsp.config("hls", { filetypes = { "haskell", "lhaskell", "cabal" } })
          vim.lsp.enable("sourcekit")
          vim.lsp.enable("unison")
          vim.lsp.enable("hls")''
        else ""
      }
    '';

    # Auto-format on save
    luaConfigRC.auto-format = ''
      vim.api.nvim_create_augroup("AutoFormatting", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        group = "AutoFormatting",
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    '';
  };
}
