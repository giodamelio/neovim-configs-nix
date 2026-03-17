_: let
  inherit (import ./lib.nix) cmd nmap;
in {
  vim = {
    binds.whichKey.register."<leader>q" = "Quickfix";

    keymaps = [
      (nmap "<leader>qq" (cmd "Trouble quickfix toggle") "Quickfix List")
      (nmap "<leader>qn" (cmd "cnext") "Next Quickfix")
      (nmap "<leader>qp" (cmd "cprev") "Previous Quickfix")
      (nmap "<leader>qc" (cmd "call setqflist([], 'f')") "Clear Quickfix List")
    ];
  };
}
