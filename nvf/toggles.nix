# Toggles/settings hub (<leader>.).
_: let
  inherit (import ./lib.nix) nmapLua;
in {
  config.vim = {
    # Which-key group
    binds.whichKey.register."<leader>." = "Toggles/Settings";

    # Toggle functions
    luaConfigRC.toggles = ''
      -- Toggle format-on-save for the session (NVF reads vim.g.formatsave on BufWritePre).
      function _G.toggle_format_on_save()
        vim.g.formatsave = not vim.g.formatsave
        vim.notify("Format on save: " .. (vim.g.formatsave and "ON" or "OFF"))
      end
    '';

    # Keymaps
    keymaps = [
      (nmapLua "<leader>.f" "toggle_format_on_save()" "Toggle format on save")
    ];
  };
}
