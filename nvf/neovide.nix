# Neovide GUI-specific settings.
_: {
  config.vim.luaConfigRC.neovide = builtins.readFile ./lua/neovide.lua;
}
