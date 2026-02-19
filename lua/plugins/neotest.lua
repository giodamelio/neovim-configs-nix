-- NeoTest
require('neotest').setup({
  adapters = {
    require('neotest-rust'),
    require('neotest-elixir'),
    require('neotest-go'),
    require('neotest-deno'),
    require('neotest-rspec'),
    require('neotest-python'),
  },
})
