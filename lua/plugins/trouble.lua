-- Trouble: pretty lists of diagnostics, references, etc.
local nix = require("lib.nix")

return {
	nix.spec("trouble.nvim", {
		cmd = { "Trouble" },
		dependencies = { "which-key.nvim" },
		keys = {
			{ "<leader>dd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble document diagnostics" },
			{ "<leader>dl", "<cmd>Trouble lsp toggle<cr>", desc = "Trouble lsp toggle" },
			{ "<leader>de", "<cmd>Trouble lsp_definitions toggle<cr>", desc = "Trouble definitions" },
			{ "<leader>di", "<cmd>Trouble lsp_implementations toggle<cr>", desc = "Trouble implementations" },
			{ "<leader>dr", "<cmd>Trouble lsp_references toggle<cr>", desc = "Trouble references" },
			{
				"<leader>dn",
				function()
					vim.diagnostic.jump({ count = 1, float = true })
				end,
				desc = "Go to next diagnostic",
			},
			{
				"<leader>dp",
				function()
					vim.diagnostic.jump({ count = -1, float = true })
				end,
				desc = "Go to previous diagnostic",
			},
		},
		config = function()
			local wk = require("which-key")
			wk.add({
				{ "<leader>d", group = "Diagnostics/Trouble" },
			})
			require("trouble").setup()
		end,
	}),
}
