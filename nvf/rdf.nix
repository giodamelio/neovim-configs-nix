# RDF editing: swls.nvim for filetype detection, swls as the language server for
# Turtle, TriG and JSON-LD.
{
  pkgs,
  vimPlugins,
  extraPkgs,
  ...
}: {
  config.vim = {
    extraPackages = [extraPkgs.swls];

    # swls.nvim ships ftdetect for .ttl/.trig/.jsonld and the matching
    # commentstrings. Its setup() is deliberately never called: it would start
    # the server through a bare vim.lsp.start (bypassing blink's capabilities and
    # nvf's on_attach) and prompt to download a release binary over the Nix one.
    startPlugins = [vimPlugins.swls-nvim];

    treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
      turtle
      json # For the jsonld filetype below. There is no trig grammar.
    ];

    # swls.nvim detects .jsonld as its own filetype, which has no grammar.
    luaConfigRC.jsonld-treesitter = ''
      vim.treesitter.language.register("json", "jsonld")
    '';

    lsp.servers.swls = {
      cmd = ["swls"];
      # SPARQL is left to qlue-ls in sparql.nix; swls calls its own support
      # experimental and ships it off by default.
      filetypes = ["turtle" "trig" "jsonld"];
      root_markers = [".git"];
      init_options.sparql = false;
    };
  };
}
