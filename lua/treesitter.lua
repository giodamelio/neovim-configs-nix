-- New nvim-treesitter (main branch) uses Neovim's built-in treesitter
-- Highlighting is enabled via vim.treesitter.start()

-- Enable treesitter highlighting for all filetypes with available parsers
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    -- Try to start treesitter highlighting, silently fail if no parser
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Enable treesitter-based indentation
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    -- Set indent expression to treesitter
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Rainbow delimiters setup
local rainbow_delimiters = require('rainbow-delimiters')
local rainbowsetup = require('rainbow-delimiters.setup')

rainbowsetup({
  strategy = {
    [''] = rainbow_delimiters.strategy['global'],
    vim = rainbow_delimiters.strategy['local'],
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  },
})

-- Enable Hurl
vim.filetype.add({
  extension = {
    hurl = 'hurl',
  },
})

-- SurrealDB treesitter support (manual setup since the nvim plugin uses the old nvim-treesitter API)
vim.filetype.add({
  extension = {
    surql = 'surrealdb',
    surrealql = 'surrealdb',
  },
})

-- Write highlight and injection queries for SurrealDB
local query_dir = vim.fn.stdpath('cache') .. '/queries/surrealdb'
vim.fn.mkdir(query_dir, 'p')

local highlights = [[
(keyword) @keyword
(string) @string
(integer) @number
(float) @number.float
(operator) @operator
(function_name) @function
(bool) @boolean
(comment) @comment
(duration) @string.special
(record_id) @type
(type) @type
(point) @number
(variable_name) @variable
(scripting_content) @none
(nothing) @constant.builtin
(null) @constant.builtin
]]

local injections = [[
((scripting_content) @injection.content
  (#set! injection.language "javascript"))
]]

local f = io.open(query_dir .. '/highlights.scm', 'w')
if f then f:write(highlights); f:close() end
f = io.open(query_dir .. '/injections.scm', 'w')
if f then f:write(injections); f:close() end
