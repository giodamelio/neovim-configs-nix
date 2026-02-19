-- Mini icons
require('mini.icons').setup()

-- Trouble
local trouble = require('trouble')
trouble.setup()

-- Snippets
require('luasnip.loaders.from_vscode').lazy_load()

-- Status bar
local lualine = require('lualine')
local default_config = lualine.get_config()

-- Enable lualine
local config = vim.tbl_deep_extend('force', default_config, {
  sections = {
    lualine_c = { 'filename', 'lsp_progress' },
  },
  winbar = {
    lualine_c = {
      {
        'navic',
        color_correction = nil,
        navic_opts = nil,
      },
    },
  },
  -- Show some help when the tabline is open, I always forget the keys...
  tabline = {
    lualine_a = { { 'tabs', mode = 2 } },
    lualine_x = { '"[next tab] gt, [prev tab] gT, [close tab] :tabclose"' },
  },
})
lualine.setup(config)

-- Hide mode display in the command bar since lualine shows it
vim.opt.showmode = false

-- Only show the tabline if there is more then one tab
vim.opt.showtabline = 1

-- Git Status in Gutter
local gs = require('gitsigns')
local gl = require('gitlinker')
local neogit = require('neogit')

gs.setup({
  current_line_blame = true,
})

gl.setup({
  mapping = nil,
})

neogit.setup()

-- Oil
require('oil').setup({
  columns = { 'icon', 'permissions', 'size' },
})

-- Other
require('other-nvim').setup({
  showMissingFiles = false, -- Don't create files automatically
  mappings = {
    'rails',
    'golang',
    -- Elixir + Phoenix Mappings

    -- Go from controller to places
    {
      pattern = '/lib/(.+)_web/controllers/(.+)_controller.ex',
      target = {
        { context = 'test', target = '/test/%1_web/controllers/%2_controller_test.exs' },
      },
    },
    -- Go from controller test to places
    {
      pattern = '/test/(.+)_web/controllers/(.+)_controller_test.exs',
      target = {
        { context = 'controller', target = '/lib/%1_web/controllers/%2_controller.ex' },
      },
    },
    -- Go from context to places
    {
      pattern = '/lib/(.+)/(.+).ex',
      target = {
        { context = 'test', target = '/test/%1/%2_test.exs' },
      },
    },
    -- Go from context test to places
    {
      pattern = '/test/(.+)/(.+)_test.exs',
      target = {
        { context = 'context', target = '/lib/%1/%2.ex' },
      },
    },

    -- TypeScript/JavaScript Test Mappings for Farmers Market

    -- Pattern 1: __tests__ directory (most common)
    -- From implementation to test
    {
      pattern = '/(.+)/([^/]+)%.ts$',
      target = {
        { context = 'test', target = '/%1/__tests__/%2.test.ts' },
      },
    },
    -- From test to implementation
    {
      pattern = '/(.+)/__tests__/([^/]+)%.test%.ts$',
      target = {
        { context = 'implementation', target = '/%1/%2.ts' },
      },
    },

    -- Pattern 2: __test__ directory (less common)
    -- From implementation to test
    {
      pattern = '/(.+)/([^/]+)%.ts$',
      target = {
        { context = 'test', target = '/%1/__test__/%2.test.ts' },
      },
    },
    -- From test to implementation
    {
      pattern = '/(.+)/__test__/([^/]+)%.test%.ts$',
      target = {
        { context = 'implementation', target = '/%1/%2.ts' },
      },
    },

    -- Pattern 3: Special case for transport-journey module structure (uses "tests" directory)
    -- From calculation.ts to calculation.test.ts
    {
      pattern = '/(.+)/modules/lifecycle/transport%-journey/calculation/([^/]+)%.ts$',
      target = {
        { context = 'test', target = '/%1/modules/lifecycle/transport-journey/tests/calculation/%2.test.ts' },
      },
    },
    -- From calculation.test.ts to calculation.ts
    {
      pattern = '/(.+)/modules/lifecycle/transport%-journey/tests/calculation/([^/]+)%.test%.ts$',
      target = {
        { context = 'implementation', target = '/%1/modules/lifecycle/transport-journey/calculation/%2.ts' },
      },
    },

    -- Pattern 4: General "tests" directory pattern (not __tests__)
    -- From implementation to test
    {
      pattern = '/(.+)/([^/]+)/([^/]+)%.ts$',
      target = {
        { context = 'test', target = '/%1/%2/tests/%3.test.ts' },
      },
    },
    -- From test to implementation
    {
      pattern = '/(.+)/([^/]+)/tests/([^/]+)%.test%.ts$',
      target = {
        { context = 'implementation', target = '/%1/%2/%3.ts' },
      },
    },

    -- Pattern 5: Farmers-market notification-service pattern
    -- From src/entrypoint/file.ts to tests/entrypoint/file-event-handler.test.ts
    {
      pattern = '/src/entrypoint/(.+)%.ts$',
      target = {
        { context = 'test', target = '/tests/entrypoint/%1-event-handler.test.ts' },
      },
    },
    -- From tests/entrypoint/file-event-handler.test.ts to src/entrypoint/file.ts
    {
      pattern = '/tests/entrypoint/(.+)%-event%-handler%.test%.ts$',
      target = {
        { context = 'implementation', target = '/src/entrypoint/%1.ts' },
      },
    },

    -- Pattern 6: Root-level test files (like mandarina manifest.test.ts)
    -- From src/file.ts to src/file.test.ts
    {
      pattern = '/src/([^/]+)%.ts$',
      target = {
        { context = 'test', target = '/src/%1.test.ts' },
      },
    },
    -- From src/file.test.ts to src/file.ts
    {
      pattern = '/src/([^/]+)%.test%.ts$',
      target = {
        { context = 'implementation', target = '/src/%1.ts' },
      },
    },

    -- Pattern 4: JavaScript files with same patterns
    -- __tests__ for JS
    {
      pattern = '/(.+)/([^/]+)%.js$',
      target = {
        { context = 'test', target = '/%1/__tests__/%2.test.js' },
      },
    },
    {
      pattern = '/(.+)/__tests__/([^/]+)%.test%.js$',
      target = {
        { context = 'implementation', target = '/%1/%2.js' },
      },
    },
    -- __test__ for JS
    {
      pattern = '/(.+)/([^/]+)%.js$',
      target = {
        { context = 'test', target = '/%1/__test__/%2.test.js' },
      },
    },
    {
      pattern = '/(.+)/__test__/([^/]+)%.test%.js$',
      target = {
        { context = 'implementation', target = '/%1/%2.js' },
      },
    },
  },
})

-- Snacks setup
local snacks = require('snacks')

local snacks_config = {
  dashboard = {
    pane_gap = 4,
    preset = {
      keys = {
        { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
        { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = ' ',
          key = 'c',
          desc = 'Config',
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.expand('$HOME/nixos-configs/nix/packages/neovim')})",
        },
        {
          icon = ' ',
          key = 'n',
          desc = 'Nix Configs',
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.expand('$HOME/nixos-configs')})",
        },
        { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
      { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
      { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
      {
        pane = 2,
        icon = ' ',
        title = 'Git Status',
        section = 'terminal',
        enabled = function()
          return snacks.git.get_root() ~= nil
        end,
        cmd = 'git status --short --branch --renames',
        height = 5,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
      },
    },
  },
  picker = {
    config = function(opts)
      -- Add an open in trouble keybinding
      return vim.tbl_deep_extend('force', opts or {}, {
        actions = require('trouble.sources.snacks').actions,
        win = {
          input = {
            keys = {
              ['<C-T>'] = {
                'trouble_open',
                mode = { 'n', 'i' },
              },
            },
          },
        },
      })
    end,
  },
  indent = {
    enable = true,
    animate = {
      enabled = false,
    },
  },
  keys = {
    config = function(opts)
      -- Add an open in trouble keybinding
      return vim.tbl_deep_extend('force', opts or {}, {
        keys = {
          {
            '<leader>/',
            function()
              snacks.terminal()
            end,
            desc = 'Toggle Terminal',
          },
        },
      })
    end,
  },
}

-- Only enable image support in the full variant
if vim.g.neovim_variant ~= 'light' then
  snacks_config.image = {
    enable = false,
  }
end

snacks.setup(snacks_config)

-- Show notification once per session when we first interact with nixos-configs
vim.api.nvim_create_autocmd('CursorMoved', {
  pattern = vim.fn.expand('~/nixos-configs') .. '/*',
  once = true,
  callback = function()
    vim.defer_fn(function()
      snacks.notifier.notify('Use :NixInstall to apply configuration', {
        title = 'Nix Configuration',
        level = 'info',
        timeout = 5000,
        icon = '❄️',
      })
    end, 500) -- Delay to ensure snacks is fully loaded
  end,
})

-- Some helper functions for debugging
-- selene: allow(multiple_statements)
_G.dd = function(...)
  snacks.debug.inspect(...)
end
-- selene: allow(multiple_statements)
_G.bt = function()
  snacks.debug.backtrace()
end
vim.print = _G.dd

-- Session management
require('persisted').setup({
  autoload = true,
})

require('Comment').setup()
require('stay-centered').setup()
require('smart-splits')
require('mini.ai').setup()
