{pkgs, ...}: let
  key = key: action: desc: {
    mode = "n";
    inherit key action desc;
  };
in {
  config.vim = {
    binds.whichKey.register."<leader>c" = "Claude Code";

    lazy.plugins."claudecode.nvim" = {
      package = pkgs.vimPlugins.claudecode-nvim;
      cmd = [
        "ClaudeCode"
        "ClaudeCodeFocus"
        "ClaudeCodeSelectModel"
        "ClaudeCodeAdd"
        "ClaudeCodeSend"
        "ClaudeCodeDiffAccept"
        "ClaudeCodeDiffDeny"
        "ClaudeCodeStatus"
      ];
      keys = [
        (key "<leader>cc" "<cmd>ClaudeCode<cr>" "Toggle Claude")
        (key "<leader>cf" "<cmd>ClaudeCodeFocus<cr>" "Focus Claude")
        (key "<leader>cr" "<cmd>ClaudeCode --resume<cr>" "Resume session")
        (key "<leader>cC" "<cmd>ClaudeCode --continue<cr>" "Continue session")
        (key "<leader>cm" "<cmd>ClaudeCodeSelectModel<cr>" "Select model")
        (key "<leader>cb" "<cmd>ClaudeCodeAdd %<cr>" "Add current buffer")
        (key "<leader>ca" "<cmd>ClaudeCodeDiffAccept<cr>" "Accept diff")
        (key "<leader>cd" "<cmd>ClaudeCodeDiffDeny<cr>" "Reject diff")
        {
          mode = "v";
          key = "<leader>cs";
          action = "<cmd>ClaudeCodeSend<cr>";
          desc = "Send selection to Claude";
        }
      ];
      setupModule = "claudecode";
      setupOpts = {};
    };
  };
}
