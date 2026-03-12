# Full Neovim variant - all plugins, all LSP servers, all treesitter grammars.
{pkgs, ...}: {
  imports = [
    ./plugins-builtin.nix
    ./plugins-custom.nix
    ./languages.nix
    ./keybindings.nix
    ./neovide.nix
  ];

  config.vim = {
    # Variant identifier
    globals.neovim_variant = "full";

    # All treesitter grammars - handled by vim.languages.* enables
    # Additional grammars can be added via:
    # treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ ... ];

    # Runtime dependencies
    extraPackages = with pkgs; [
      ripgrep
      fd
      git
      imagemagick # Snacks: For inline images
      netcat-gnu # For Unison LSP
    ];
  };
}
