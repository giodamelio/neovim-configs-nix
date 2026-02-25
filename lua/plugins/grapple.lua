-- Grapple: quick file tagging and navigation
local nix = require("lib.nix")

return {
	nix.spec("grapple.nvim", {
		cmd = "Grapple",
		dependencies = { "which-key.nvim" },
		keys = {
			{ "<leader><leader><Tab>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
			{ "<leader><leader><Tab>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
			{ "<leader><leader><Tab>n", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
			{ "<leader><leader><Tab>p", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
		},
		config = function()
			local wk = require("which-key")
			wk.add({
				{ "<leader><leader><Tab>", group = "Grapple" },
			})
			require("grapple").setup()
		end,
	}),
}
