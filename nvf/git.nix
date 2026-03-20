# Git integration - gitsigns, neogit, gitlinker, diffview.
_: let
  inherit (import ./lib.nix) cmd nmap nmapLua mapLua;
in {
  config.vim = {
    # Which-key group
    binds.whichKey.register."<leader>g" = "Git";

    # Git plugins
    git = {
      gitsigns.enable = true;
      neogit.enable = true;
      hunk-nvim.enable = true;
      gitlinker-nvim = {
        enable = true;
        setupOpts = {
          mapping = null; # Disable default mapping, we define our own
        };
      };
    };
    utility.diffview-nvim.enable = true;

    # Git keymaps
    keymaps = [
      (nmapLua "<leader>gb" "Snacks.git.blame_line()" "Blame current line")
      (nmapLua "<leader>gn" "require('gitsigns').next_hunk()" "Next hunk")
      (nmapLua "<leader>gp" "require('gitsigns').prev_hunk()" "Previous hunk")
      (mapLua ["n" "v"] "<leader>gr" "require('gitsigns').reset_hunk()" "Reset hunk")
      (mapLua ["n" "v"] "<leader>gs" "require('gitsigns').stage_hunk()" "Stage hunk")
      (nmapLua "<leader>gu" "require('gitsigns').undo_stage_hunk()" "Unstage hunk")
      (nmapLua "<leader>go" "Snacks.gitbrowse()" "Open file in browser")
      (nmap "<leader>gg" (cmd "Neogit") "Open Neogit")
    ];

    # Gitlinker keybind setup
    luaConfigRC.gitlinker-keybindings = builtins.readFile ./lua/gitlinker-keybindings.lua;
  };
}
