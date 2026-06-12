{
  pkgs,
  lib,
  vimPlugins,
  ...
}: let
  inherit (import ./lib.nix) cmd nmap map nmapLua;
  inherit (lib.generators) mkLuaInline;
in {
  config.vim = {
    # CodeCompanion's claude_code adapter execs this; needs to be on PATH.
    extraPackages = [pkgs.claude-agent-acp];

    binds.whichKey.register = {
      "<leader>a" = "AI";
      "<leader>ar" = "Review";
    };

    # Claude Code over ACP: uses the Max subscription via CLAUDE_CODE_OAUTH_TOKEN
    # (from `claude setup-token`), not a metered API key.
    assistant.codecompanion-nvim = {
      enable = true;
      setupOpts = {
        strategies = {
          chat = {
            adapter = "claude_code";
            # Setting `modes` replaces the defaults, so re-list them. <C-CR> is
            # inert until the terminal speaks the Kitty keyboard protocol.
            keymaps.send.modes = {
              n = ["<CR>" "<C-s>"];
              i = ["<C-s>" "<C-CR>"];
            };
          };
          inline.adapter = "claude_code";
        };
        # Read the token from the env rather than hardcoding the secret.
        adapters = mkLuaInline ''
          {
            acp = {
              claude_code = function()
                return require("codecompanion.adapters").extend("claude_code", {
                  env = {
                    CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN",
                  },
                })
              end,
            },
          }
        '';
      };
    };

    # Eager: libraries with no setup of their own.
    startPlugins = [
      vimPlugins.codediff-nvim
      pkgs.vimPlugins.nui-nvim
    ];

    lazy.plugins."review.nvim" = {
      package = vimPlugins.review-nvim;
      cmd = ["Review"];
      setupModule = "review";
      setupOpts = {};
    };

    luaConfigRC.review-integration = builtins.readFile ./lua/review-integration.lua;

    # codediff's .git fs_event watcher self-loops in jj repos (constant index
    # churn) -> continuous diff repaint. review.nvim never calls codediff.setup.
    luaConfigRC.codediff-config = ''
      pcall(function()
        require("codediff").setup({explorer = {auto_refresh = false}})
      end)
    '';

    keymaps = [
      (map ["n" "x"] "<leader>aa" (cmd "CodeCompanionActions") "Action palette")
      (map ["n" "x"] "<leader>ac" (cmd "CodeCompanionChat Toggle") "Toggle chat")
      (map ["n" "x"] "<leader>ai" (cmd "CodeCompanion") "Inline assistant")
      (map ["x"] "<leader>av" (cmd "CodeCompanionChat Add") "Add selection to chat")

      (nmap "<leader>arr" (cmd "Review") "Open diff review")
      (nmap "<leader>arc" (cmd "Review commits") "Review commits")
      (nmap "<leader>are" (cmd "Review export") "Export comments to clipboard")
      (nmap "<leader>arx" (cmd "Review close") "Close review & export")
      (nmapLua "<leader>ars" "_G.AIReview.to_codecompanion()" "Send review to CodeCompanion")
      (nmapLua "<leader>arS" "_G.AIReview.to_claudecode()" "Send review to Claude Code")
    ];
  };
}
