# In-editor diff review with comments, exported to an AI assistant.
{
  pkgs,
  lib,
  vimPlugins,
  ...
}: let
  inherit (import ./lib.nix) cmd nmap nmapLua;
in {
  config.vim = {
    binds.whichKey.register."<leader>ar" = "Review";

    # review.picker builds its modal out of nui.
    startPlugins = [pkgs.vimPlugins.nui-nvim];

    # Swap the diffview enabled in git.nix for the diffview-plus fork, which is
    # the only one review.nvim's diffview backend can drive against jj.
    lazy.plugins.diffview-nvim.package = lib.mkForce vimPlugins.diffview-nvim;

    # Colocated repos have both .jj and .git, and adapter detection takes the
    # first that matches. Only reorders the candidates, so git-only repos still
    # resolve to git.
    utility.diffview-nvim.setupOpts.preferred_adapter = "jj";

    lazy.plugins."review.nvim" = {
      package = vimPlugins.review-nvim;
      cmd = ["Review"];
      # review.setup resolves the backend eagerly, and diffview is itself lazy
      # on its own commands, so pull it in first or the backend resolves to nil.
      before = ''require("lz.n").trigger_load("diffview-nvim")'';
      setupModule = "review";
      setupOpts.backend = "diffview";
    };

    luaConfigRC.review-integration = builtins.readFile ./lua/review-integration.lua;

    keymaps = [
      (nmap "<leader>arr" (cmd "Review") "Open diff review")
      (nmap "<leader>arc" (cmd "Review commits") "Review commits")
      (nmap "<leader>are" (cmd "Review export") "Export comments to clipboard")
      (nmap "<leader>arx" (cmd "Review close") "Close review & export")
      (nmapLua "<leader>ars" "_G.AIReview.to_codecompanion()" "Send review to CodeCompanion")
      (nmapLua "<leader>arS" "_G.AIReview.to_claudecode()" "Send review to Claude Code")
    ];
  };
}
