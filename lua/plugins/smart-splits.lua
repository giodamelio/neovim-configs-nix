-- Smart splits: pane navigation, resizing, and buffer swapping
local smart_split = require("smart-splits")

-- Pane resize
vim.keymap.set("n", "<A-h>", smart_split.resize_left)
vim.keymap.set("n", "<A-j>", smart_split.resize_down)
vim.keymap.set("n", "<A-k>", smart_split.resize_up)
vim.keymap.set("n", "<A-l>", smart_split.resize_right)

-- Moving between splits
vim.keymap.set({ "n", "t", "v" }, "<C-h>", smart_split.move_cursor_left)
vim.keymap.set({ "n", "t", "v" }, "<C-j>", smart_split.move_cursor_down)
vim.keymap.set({ "n", "t", "v" }, "<C-k>", smart_split.move_cursor_up)
vim.keymap.set({ "n", "t", "v" }, "<C-l>", smart_split.move_cursor_right)
vim.keymap.set("n", "<C-\\>", smart_split.move_cursor_previous)

-- Swapping buffers between windows
vim.keymap.set("n", "<leader><leader>h", smart_split.swap_buf_left)
vim.keymap.set("n", "<leader><leader>j", smart_split.swap_buf_down)
vim.keymap.set("n", "<leader><leader>k", smart_split.swap_buf_up)
vim.keymap.set("n", "<leader><leader>l", smart_split.swap_buf_right)
