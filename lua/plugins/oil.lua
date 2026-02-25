-- Oil file explorer
local nix = require("lib.nix")

return {
	nix.spec("oil.nvim", {
		cmd = "Oil",
		opts = {
			columns = { "icon", "permissions", "size" },
		},
	}),
}
