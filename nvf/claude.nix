# Claude Code integration (full variant only).
{pkgs, ...}: {
  config.vim = {
    # Which-key group
    binds.whichKey.register."<leader>c" = "Claude";

    # Claude Code plugin
    lazy.plugins."claudecode.nvim" = {
      package = pkgs.vimPlugins.claudecode-nvim;
      cmd = ["ClaudeCode" "ClaudeCodeFocus" "ClaudeCodeToggle"];
      keys = [
        {
          mode = "n";
          key = "<leader>cc";
          action = "<cmd>ClaudeCodeToggle<cr>";
          desc = "Toggle Claude";
        }
        {
          mode = "n";
          key = "<leader>cf";
          action = "<cmd>ClaudeCodeFocus<cr>";
          desc = "Focus Claude";
        }
      ];
      setupModule = "claudecode";
      setupOpts = {};
    };
  };
}
