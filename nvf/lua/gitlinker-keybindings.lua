-- Gitlinker keybind setup.
local gitlinker_ok, gitlinker = pcall(require, "gitlinker")
if gitlinker_ok then
	vim.keymap.set({ "n", "v" }, "<leader>gy", function()
		gitlinker.link({
			action = function(url)
				vim.fn.setreg('"', url)
			end,
			lstart = vim.api.nvim_buf_get_mark(0, "<")[1],
			lend = vim.api.nvim_buf_get_mark(0, ">")[1],
		})
	end, { desc = "Copy permalink" })
end
