# TODO

- [ ] **2026-08-25**: Check if [tree-sitter-surrealdb.nvim](https://github.com/DariusCorvus/tree-sitter-surrealdb.nvim) has been updated for the new nvim-treesitter API. Re-add SurrealDB syntax highlighting if compatible. (Removed in Feb 2026 due to incompatibility with nvim-treesitter rewrite)

- [ ] Expand and Shrink key bindings on the AST level via treesitter. /vs_codelike_expand_selection_via_treesitter

- [ ] Telescope AST search. https://github.com/ray-x/telescope-ast-grep.nvim

- [ ] Try out NVF again. Maybe it's lazy loading would work fine.

- [ ] Make a super leight weight config that is portable to external Neovim and normal Vim, it should be a derivation that builds a .vimrc.
  - [ ] A curl piped to sh script to run it anywhere. So I can do `curl https://vim.giodamelio.com | sh` to get at least a basic editor on any computer that has Vim installed.
  - [ ] Maybe an advanced version that detects neovim and installs a more advanced (but still basic) lua config.
