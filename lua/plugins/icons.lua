local nix = require("lib.nix")

return {
	nix.spec("nvim-web-devicons", {
		lazy = true,
		config = true,
	}),
	nix.spec("lspkind.nvim", {
		lazy = true,
	}),
}
