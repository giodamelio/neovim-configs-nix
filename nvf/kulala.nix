# Kulala - an HTTP REST client in Neovim (works on .http/.rest files).
{pkgs, ...}: let
  key = key: action: desc: {
    mode = "n";
    inherit key action desc;
  };
in {
  config.vim = {
    binds.whichKey.register."<leader>R" = "REST (Kulala)";

    # curl sends the requests; jq formats JSON in the response view.
    extraPackages = with pkgs; [curl jq];

    treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.grammarPlugins.http];

    luaConfigRC.kulala-filetype = ''
      vim.filetype.add({
        extension = {
          ["http"] = "http",
          ["rest"] = "http",
        },
      })
    '';

    lazy.plugins."kulala.nvim" = {
      package = pkgs.vimPlugins.kulala-nvim;
      ft = ["http" "rest"];
      keys = [
        (key "<leader>Rr" "<cmd>lua require('kulala').run()<cr>" "Send request")
        (key "<leader>Ra" "<cmd>lua require('kulala').run_all()<cr>" "Send all requests")
        (key "<leader>RR" "<cmd>lua require('kulala').replay()<cr>" "Replay last request")
        (key "<leader>Rn" "<cmd>lua require('kulala').jump_next()<cr>" "Next request")
        (key "<leader>Rp" "<cmd>lua require('kulala').jump_prev()<cr>" "Previous request")
        (key "<leader>Rt" "<cmd>lua require('kulala').toggle_view()<cr>" "Toggle body/headers view")
        (key "<leader>Rc" "<cmd>lua require('kulala').copy()<cr>" "Copy request as curl")
        (key "<leader>RC" "<cmd>lua require('kulala').from_curl()<cr>" "Paste curl as request")
        (key "<leader>Rq" "<cmd>lua require('kulala').close()<cr>" "Close Kulala window")
        (key "<leader>Re" "<cmd>lua require('kulala').set_selected_env()<cr>" "Select environment")
        (key "<leader>RS" "<cmd>lua require('kulala').scratchpad()<cr>" "Open scratchpad")
      ];
      setupModule = "kulala";
      setupOpts = {};
    };
  };
}
