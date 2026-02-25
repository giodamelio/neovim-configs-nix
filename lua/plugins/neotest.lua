-- NeoTest: test running framework
local nix = require("lib.nix")

return {
	-- Main neotest plugin
	nix.spec("neotest", {
		dependencies = {
			"nvim-nio",
			"which-key.nvim",
			"neotest-rust",
			"neotest-elixir",
			"neotest-go",
			"neotest-deno",
			"neotest-rspec",
			"neotest-python",
		},
		keys = {
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run tests in file",
			},
			{
				"<leader>tp",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle output panel",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle summary",
			},
			{
				"<leader>tt",
				function()
					require("neotest").run.run()
				end,
				desc = "Run nearest test",
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Watch tests in file",
			},
			{
				"<leader>ta",
				function()
					require("neotest").run.attach()
				end,
				desc = "Attach to running test",
			},
			{
				"<leader>tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run last test",
			},
		},
		config = function()
			local wk = require("which-key")
			wk.add({
				{ "<leader>t", group = "Testing" },
			})

			require("neotest").setup({
				adapters = {
					require("neotest-rust"),
					require("neotest-elixir"),
					require("neotest-go"),
					require("neotest-deno"),
					require("neotest-rspec"),
					require("neotest-python"),
				},
			})
		end,
	}),

	-- Dependency
	nix.spec("nvim-nio", { lazy = true }),

	-- Adapters
	nix.spec("neotest-rust", { lazy = true }),
	nix.spec("neotest-elixir", { lazy = true }),
	nix.spec("neotest-go", { lazy = true }),
	nix.spec("neotest-deno", { lazy = true }),
	nix.spec("neotest-rspec", { lazy = true }),
	nix.spec("neotest-python", { lazy = true }),
}
