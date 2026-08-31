# SPARQL editing: qluels-nvim driving the qlue-ls language server.
{
  pkgs,
  lib,
  vimPlugins,
  extraPkgs,
  ...
}: let
  inherit (lib.generators) mkLuaInline;
  inherit (import ./lib.nix) cmd nmap map;
in {
  config.vim = {
    binds.whichKey.register."<leader>s" = "SPARQL";

    extraPackages = [extraPkgs.qlue-ls];

    treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.grammarPlugins.sparql];

    lazy.plugins."qluels-nvim" = {
      package = vimPlugins.qluels-nvim;
      # Neovim already maps .sparql and .rq to the sparql filetype.
      ft = ["sparql"];
      cmd = [
        "QluelsAddBackend"
        "QluelsSetBackend"
        "QluelsListBackends"
        "QLuelsPingBackend"
        "QluelsExecute"
        "QluelsExecuteSelection"
        "QluelsCloseResults"
        "QluelsReload"
        "QluelsGetDefaultSettings"
        "QluelsLibraryExecute"
        "QluelsLibraryLoad"
        "QluelsParseTree"
      ];
      setupModule = "qluels";
      setupOpts = {
        # qluels calls vim.lsp.start itself rather than registering through
        # vim.lsp.config, so blink's capabilities have to be handed to it here.
        server = {
          capabilities = mkLuaInline "require('blink.cmp').get_lsp_capabilities()";
          filetypes = ["sparql"];
        };
        # Read by setup() off the raw opts table, not the merged defaults, so it
        # has to be spelled out even though the default is true.
        auto_attach = true;
        on_type_formatting = true;
      };
    };

    keymaps = [
      (nmap "<leader>se" (cmd "QluelsExecute") "Execute buffer as query")
      (map ["v"] "<leader>se" (cmd "QluelsExecuteSelection") "Execute selection as query")
      (nmap "<leader>sq" (cmd "QluelsCloseResults") "Close results window")
      (nmap "<leader>sb" (cmd "QluelsSetBackend") "Pick backend")
      (nmap "<leader>sB" (cmd "QluelsListBackends") "List backends")
      (nmap "<leader>sp" (cmd "QLuelsPingBackend") "Ping backend")
      (nmap "<leader>sl" (cmd "QluelsLibraryExecute") "Execute query from library")
      (nmap "<leader>sL" (cmd "QluelsLibraryLoad") "Load query from library")
      (nmap "<leader>sT" (cmd "QluelsParseTree") "Show parse tree")
    ];
  };
}
