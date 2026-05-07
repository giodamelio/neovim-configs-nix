# Jujutsu (jj) version control integration.
{vimPlugins, ...}: let
  inherit (import ./lib.nix) cmd nmap nmapLua;
in {
  config.vim = {
    # Which-key group
    binds.whichKey.register."<leader>j" = "Jujutsu";

    # Lazy plugins
    lazy.plugins."jj.nvim" = {
      package = vimPlugins.jj-nvim;
      cmd = ["J"];
      setupModule = "jj";
      setupOpts = {};
    };

    # Keymaps
    keymaps = [
      (nmap "<leader>js" (cmd "J") "Jujutsu status")
      (nmap "<leader>jl" (cmd "J log") "Jujutsu log")
      (nmapLua "<leader>jj" "require('jj.picker').status()" "Jujutsu status picker")
      (nmapLua "<leader>jL" "require('jj.cmd').log { revisions = \"all()\" }" "Jujutsu log all")
    ];
  };
}
