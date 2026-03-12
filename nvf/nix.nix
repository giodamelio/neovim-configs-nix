# NixOS configuration helpers - NixInstall command.
_: {
  config.vim.luaConfigRC.nix-install = builtins.readFile ./lua/nix-install.lua;
}
