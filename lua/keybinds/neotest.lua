local wk = require('which-key')
local neotest = require('neotest')

-- Testing
wk.add({
  { '<leader>t', group = 'Testing' },
  {
    '<leader>tf',
    function()
      neotest.run.run(vim.fn.expand('%'))
    end,
    desc = 'Run tests in file',
  },
  {
    '<leader>tp',
    function()
      neotest.output_panel.toggle()
    end,
    desc = 'Toggle output panel',
  },
  {
    '<leader>ts',
    function()
      neotest.summary.toggle()
    end,
    desc = 'Toggle summary',
  },
  {
    '<leader>tt',
    function()
      neotest.run.run()
    end,
    desc = 'Run nearest test',
  },
  {
    '<leader>tw',
    function()
      neotest.watch.toggle(vim.fn.expand('%'))
    end,
    desc = 'Watch tests in file',
  },
  {
    '<leader>ta',
    function()
      neotest.run.attach()
    end,
    desc = 'Attach to running test',
  },
  {
    '<leader>tl',
    function()
      neotest.run.run_last()
    end,
    desc = 'Run last test',
  },
})
