# Treefmt integration - format commands and keybindings.
_: {
  config.vim.luaConfigRC.treefmt = builtins.readFile ./lua/treefmt.lua;
}
