# Git integration - gitsigns, neogit, gitlinker, diffview.
{pkgs, ...}: let
  inherit (import ./lib.nix) cmd nmap nmapLua mapLua;
in {
  config.vim = {
    pluginOverrides = {
      hunk-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "hunk-nvim";
        version = "unstable-2025-03-20";
        src = pkgs.fetchFromGitHub {
          owner = "giodamelio";
          repo = "hunk.nvim";
          rev = "f71cb42df146571f1a23db1c990f8128c417bf8f";
          hash = "sha256-8UZAPSETDrXqYBSg/ohxng3TihKuhzezc8n4MxBI4u8=";
        };
        nvimSkipModules = [
          "hunk"
          "hunk.ui.tree"
          "hunk.ui.help_bar"
          "hunk.ui.help"
          "hunk.ui.init"
        ];
      };
    };

    # Which-key group
    binds.whichKey.register."<leader>g" = "Git";

    # Git plugins
    git = {
      gitsigns.enable = true;
      neogit.enable = true;
      hunk-nvim = {
        enable = true;
        setupOpts.ui.help_bar = true;
      };
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
