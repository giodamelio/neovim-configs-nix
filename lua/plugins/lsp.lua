local nix = require("lib.nix")

return {
	-- Completion git source (optional, full variant only)
	nix.spec("blink-cmp-git", { lazy = true }),

	-- Navic for code context in winbar
	nix.spec("nvim-navic", { lazy = true }),

	nix.spec("blink.cmp", {
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = { "mini.icons", "lspkind.nvim" }, -- blink-cmp-git is optional, handled via pcall
		config = function()
			local blink = require("blink.cmp")
			local mini_icons = require("mini.icons")

			-- Load some additional providers (optional, not present in all variants)
			local has_blink_cmp_git = pcall(require, "blink-cmp-git")

			blink.setup({
				keymap = { preset = "default" },

				appearance = {
					nerd_font_variant = "mono",
				},

				completion = {
					documentation = { auto_show = false },

					-- Draw the menu with mini.icons and lspkind
					menu = {
						draw = {
							columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
							components = {
								kind_icon = {
									text = function(ctx)
										if vim.tbl_contains({ "Path" }, ctx.source_name) then
											local mini_icon, _ = mini_icons.get(ctx.item.data.type, ctx.label)
											if mini_icon then
												return mini_icon .. ctx.icon_gap
											end
										end

										local icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
										return icon .. ctx.icon_gap
									end,

									-- Optionally, use the highlight groups from mini.icons
									-- You can also add the same function for `kind.highlight` if you want to
									-- keep the highlight groups in sync with the icons.
									highlight = function(ctx)
										if vim.tbl_contains({ "Path" }, ctx.source_name) then
											local mini_icon, mini_hl = mini_icons.get(ctx.item.data.type, ctx.label)
											if mini_icon then
												return mini_hl
											end
										end
										return ctx.kind_hl
									end,
								},
								kind = {
									-- Optional, use highlights from mini.icons
									highlight = function(ctx)
										if vim.tbl_contains({ "Path" }, ctx.source_name) then
											local mini_icon, mini_hl = mini_icons.get(ctx.item.data.type, ctx.label)
											if mini_icon then
												return mini_hl
											end
										end
										return ctx.kind_hl
									end,
								},
							},
						},
					},
				},

				sources = {
					default = has_blink_cmp_git and { "lsp", "path", "snippets", "buffer", "git" }
						or { "lsp", "path", "snippets", "buffer" },
					providers = {
						lsp = {
							score_offset = 1,
						},
						snippets = {
							score_offset = 2,
						},
						buffer = {
							score_offset = 3,
							min_keyword_length = 3,
						},
						path = {
							score_offset = 4,
						},
						git = has_blink_cmp_git
								and {
									module = "blink-cmp-git",
									name = "Git",
									opts = {},
									-- This should ALWAYS go last
									score_offset = -10000,
									min_keyword_length = 4,
								}
							or nil,
					},
				},

				signature = { enabled = true },

				fuzzy = { implementation = "prefer_rust_with_warning" },
			})
		end,
	}),

	nix.spec("nvim-lspconfig", {
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-navic", "blink.cmp" },
		config = function()
			local navic = require("nvim-navic")
			local blink = require("blink.cmp")

			-- Set the default capabilities
			vim.lsp.config("*", {
				capabilities = vim.tbl_deep_extend(
					"force",
					vim.lsp.protocol.make_client_capabilities(),
					blink.get_lsp_capabilities({}, false)
				),
				on_attach = function(client, bufnr)
					-- Attach Navic
					-- selene: allow(multiple_statements)
					if client.server_capabilities.documentSymbolProvider then
						navic.attach(client, bufnr)
					end
				end,
			})

			vim.lsp.config("expert", {
				cmd = { "expert", "--stdio" },
				root_markers = { "mix.exs" },
				filetypes = { "elixir", "eelixir", "heex", "surface" },
			})

			vim.lsp.config("emmet_ls", {
				filetypes = { "css", "html", "javascript", "heex", "htmldjango" },
			})

			vim.lsp.config("lexical", {
				cmd = { "lexical" },
			})

			vim.lsp.config("rust_analyzer", {
				settings = {
					["rust-analyzer"] = {
						check = {
							command = "clippy",
						},
					},
				},
			})

			vim.lsp.config("nil_ls", {
				settings = {
					["nil"] = {
						formatting = {
							command = { "alejandra" },
						},
					},
				},
			})

			vim.lsp.enable("nil_ls")
			vim.lsp.enable("nixd")
			vim.lsp.enable("expert")
			vim.lsp.enable("nextls")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("emmet_ls")
			vim.lsp.enable("lexical")
			vim.lsp.enable("rust_analyzer")

			-- Python
			vim.lsp.enable("basedpyright")
			vim.lsp.enable("ruff")

			-- Autoformat before save
			vim.api.nvim_create_augroup("AutoFormatting", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				group = "AutoFormatting",
				callback = function()
					vim.lsp.buf.format()
				end,
			})

			-- LSP keybindings (pure vim.lsp, no plugin dependency)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover docs" })
			vim.keymap.set("n", "<leader>ll", vim.lsp.buf.code_action, { desc = "Show code actions" })
			vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })
			vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, { desc = "Rename under cursor" })

			-- Full variant extras
			if vim.g.neovim_variant == "full" then
				vim.lsp.config("hls", { filetypes = { "haskell", "lhaskell", "cabal" } })
				vim.lsp.enable("sourcekit")
				vim.lsp.enable("unison")
				vim.lsp.enable("hls")
			end
		end,
	}),
}
