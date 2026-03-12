# Neovide GUI-specific settings.
_: {
  config.vim.luaConfigRC.neovide = ''
    if vim.g.neovide then
      -- Cursor settings
      vim.g.neovide_cursor_vfx_mode = "railgun"
      vim.g.neovide_cursor_animation_length = 0.05
      vim.g.neovide_cursor_trail_size = 0.3

      -- Scroll animation
      vim.g.neovide_scroll_animation_length = 0.1

      -- Zoom keybindings
      vim.g.neovide_scale_factor = 1.0

      local function change_scale_factor(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
      end

      -- Mac keybindings (Cmd)
      vim.keymap.set("n", "<D-=>", function() change_scale_factor(1.25) end, { desc = "Zoom in" })
      vim.keymap.set("n", "<D-->", function() change_scale_factor(1/1.25) end, { desc = "Zoom out" })
      vim.keymap.set("n", "<D-0>", function() vim.g.neovide_scale_factor = 1.0 end, { desc = "Reset zoom" })

      -- Linux keybindings (Ctrl)
      vim.keymap.set("n", "<C-=>", function() change_scale_factor(1.25) end, { desc = "Zoom in" })
      vim.keymap.set("n", "<C-->", function() change_scale_factor(1/1.25) end, { desc = "Zoom out" })
      vim.keymap.set("n", "<C-0>", function() vim.g.neovide_scale_factor = 1.0 end, { desc = "Reset zoom" })

      -- Fullscreen toggle
      vim.keymap.set("n", "<F11>", function()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
      end, { desc = "Toggle fullscreen" })
    end
  '';
}
