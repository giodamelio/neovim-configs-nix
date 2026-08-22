{
  pkgs,
  lib,
  ...
}: let
  inherit (import ./lib.nix) cmd map;
  inherit (lib.generators) mkLuaInline;
in {
  imports = [./review.nix];

  config.vim = {
    # CodeCompanion's claude_code adapter execs this; needs to be on PATH.
    extraPackages = [pkgs.claude-agent-acp];

    binds.whichKey.register."<leader>a" = "AI";

    # Visual mode whichkey groups
    luaConfigRC.ai-whichkey-visual = ''
      require("which-key").add({
        { "<leader>a", group = "AI", mode = "x" },
      })
    '';

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
        adapters = mkLuaInline ''
          {
            acp = {
              claude_code = function()
                return require("codecompanion.adapters").extend("claude_code", {
                  env = {
                    -- Fetch the token from 1Password at launch via the `cmd:` prefix
                    CLAUDE_CODE_OAUTH_TOKEN = "cmd:op read op://oyflrphtzxawut5aqmgvhji4he/rkunxmv5u6ybvueddvhq63pscm/credential --no-newline",
                  },
                })
              end,
            },
          }
        '';
      };
    };

    keymaps = [
      (map ["n" "x"] "<leader>aa" (cmd "CodeCompanionActions") "Action palette")
      (map ["n" "x"] "<leader>ac" (cmd "CodeCompanionChat Toggle") "Toggle chat")
      (map ["n" "x"] "<leader>ai" (cmd "CodeCompanion") "Inline assistant")
      (map ["x"] "<leader>av" (cmd "CodeCompanionChat Add") "Add selection to chat")
    ];
  };
}
