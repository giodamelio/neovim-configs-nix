# Neotest - testing framework (full variant only).
{pkgs, ...}: let
  inherit (import ./lib.nix) nmapLua;
in {
  config.vim = {
    # Neotest and adapters
    startPlugins = with pkgs.vimPlugins; [
      neotest
      nvim-nio
      neotest-rust
      neotest-elixir
      neotest-go
      neotest-deno
      neotest-rspec
      neotest-python
    ];

    # Test keymaps
    keymaps = [
      (nmapLua "<leader>tt" "require('neotest').run.run()" "Run nearest test")
      (nmapLua "<leader>tf" "require('neotest').run.run(vim.fn.expand('%'))" "Run file tests")
      (nmapLua "<leader>ts" "require('neotest').summary.toggle()" "Toggle summary")
      (nmapLua "<leader>tp" "require('neotest').output_panel.toggle()" "Toggle output panel")
      (nmapLua "<leader>tw" "require('neotest').watch.toggle(vim.fn.expand('%'))" "Watch tests")
      (nmapLua "<leader>ta" "require('neotest').run.attach()" "Attach to test")
      (nmapLua "<leader>tl" "require('neotest').run.run_last()" "Run last test")
    ];

    # Neotest setup
    luaConfigRC.neotest-setup = builtins.readFile ./lua/neotest-setup.lua;
  };
}
