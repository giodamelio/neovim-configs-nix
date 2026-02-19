-- Other: navigate to related files
local wk = require("which-key")

require("other-nvim").setup({
	showMissingFiles = false, -- Don't create files automatically
	mappings = {
		"rails",
		"golang",
		-- Elixir + Phoenix Mappings

		-- Go from controller to places
		{
			pattern = "/lib/(.+)_web/controllers/(.+)_controller.ex",
			target = {
				{ context = "test", target = "/test/%1_web/controllers/%2_controller_test.exs" },
			},
		},
		-- Go from controller test to places
		{
			pattern = "/test/(.+)_web/controllers/(.+)_controller_test.exs",
			target = {
				{ context = "controller", target = "/lib/%1_web/controllers/%2_controller.ex" },
			},
		},
		-- Go from context to places
		{
			pattern = "/lib/(.+)/(.+).ex",
			target = {
				{ context = "test", target = "/test/%1/%2_test.exs" },
			},
		},
		-- Go from context test to places
		{
			pattern = "/test/(.+)/(.+)_test.exs",
			target = {
				{ context = "context", target = "/lib/%1/%2.ex" },
			},
		},

		-- TypeScript/JavaScript Test Mappings for Farmers Market

		-- Pattern 1: __tests__ directory (most common)
		-- From implementation to test
		{
			pattern = "/(.+)/([^/]+)%.ts$",
			target = {
				{ context = "test", target = "/%1/__tests__/%2.test.ts" },
			},
		},
		-- From test to implementation
		{
			pattern = "/(.+)/__tests__/([^/]+)%.test%.ts$",
			target = {
				{ context = "implementation", target = "/%1/%2.ts" },
			},
		},

		-- Pattern 2: __test__ directory (less common)
		-- From implementation to test
		{
			pattern = "/(.+)/([^/]+)%.ts$",
			target = {
				{ context = "test", target = "/%1/__test__/%2.test.ts" },
			},
		},
		-- From test to implementation
		{
			pattern = "/(.+)/__test__/([^/]+)%.test%.ts$",
			target = {
				{ context = "implementation", target = "/%1/%2.ts" },
			},
		},

		-- Pattern 3: Special case for transport-journey module structure (uses "tests" directory)
		-- From calculation.ts to calculation.test.ts
		{
			pattern = "/(.+)/modules/lifecycle/transport%-journey/calculation/([^/]+)%.ts$",
			target = {
				{ context = "test", target = "/%1/modules/lifecycle/transport-journey/tests/calculation/%2.test.ts" },
			},
		},
		-- From calculation.test.ts to calculation.ts
		{
			pattern = "/(.+)/modules/lifecycle/transport%-journey/tests/calculation/([^/]+)%.test%.ts$",
			target = {
				{ context = "implementation", target = "/%1/modules/lifecycle/transport-journey/calculation/%2.ts" },
			},
		},

		-- Pattern 4: General "tests" directory pattern (not __tests__)
		-- From implementation to test
		{
			pattern = "/(.+)/([^/]+)/([^/]+)%.ts$",
			target = {
				{ context = "test", target = "/%1/%2/tests/%3.test.ts" },
			},
		},
		-- From test to implementation
		{
			pattern = "/(.+)/([^/]+)/tests/([^/]+)%.test%.ts$",
			target = {
				{ context = "implementation", target = "/%1/%2/%3.ts" },
			},
		},

		-- Pattern 5: Farmers-market notification-service pattern
		-- From src/entrypoint/file.ts to tests/entrypoint/file-event-handler.test.ts
		{
			pattern = "/src/entrypoint/(.+)%.ts$",
			target = {
				{ context = "test", target = "/tests/entrypoint/%1-event-handler.test.ts" },
			},
		},
		-- From tests/entrypoint/file-event-handler.test.ts to src/entrypoint/file.ts
		{
			pattern = "/tests/entrypoint/(.+)%-event%-handler%.test%.ts$",
			target = {
				{ context = "implementation", target = "/src/entrypoint/%1.ts" },
			},
		},

		-- Pattern 6: Root-level test files (like mandarina manifest.test.ts)
		-- From src/file.ts to src/file.test.ts
		{
			pattern = "/src/([^/]+)%.ts$",
			target = {
				{ context = "test", target = "/src/%1.test.ts" },
			},
		},
		-- From src/file.test.ts to src/file.ts
		{
			pattern = "/src/([^/]+)%.test%.ts$",
			target = {
				{ context = "implementation", target = "/src/%1.ts" },
			},
		},

		-- Pattern 4: JavaScript files with same patterns
		-- __tests__ for JS
		{
			pattern = "/(.+)/([^/]+)%.js$",
			target = {
				{ context = "test", target = "/%1/__tests__/%2.test.js" },
			},
		},
		{
			pattern = "/(.+)/__tests__/([^/]+)%.test%.js$",
			target = {
				{ context = "implementation", target = "/%1/%2.js" },
			},
		},
		-- __test__ for JS
		{
			pattern = "/(.+)/([^/]+)%.js$",
			target = {
				{ context = "test", target = "/%1/__test__/%2.test.js" },
			},
		},
		{
			pattern = "/(.+)/__test__/([^/]+)%.test%.js$",
			target = {
				{ context = "implementation", target = "/%1/%2.js" },
			},
		},
	},
})

-- Other file keybindings
wk.add({
	{ "<leader>o", group = "Other files" },
})

vim.keymap.set("n", "<leader>oc", "<cmd>OtherClear<cr>", { desc = "Clear the internal reference to other file" })
vim.keymap.set("n", "<leader>oo", "<cmd>Other<cr>", { desc = "Open the the other file" })
vim.keymap.set("n", "<leader>os", "<cmd>OtherSplit<cr>", { desc = "Open the the other file in a horizontal split" })
vim.keymap.set("n", "<leader>ov", "<cmd>OtherVSplit<cr>", { desc = "Open the the other file in a vertical split" })
