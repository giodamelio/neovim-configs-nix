# Light Neovim variant - core plugins only, minimal closure size.
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
    globals.neovim_variant = "light";

    # Treesitter grammars are handled by vim.languages.* enables
    # in languages.nix - no need to specify them here

    # Disable git plugins (not in light variant)
    git = {
      gitsigns.enable = false;
      neogit.enable = false;
      gitlinker-nvim.enable = false;
    };

    # Runtime dependencies
    extraPackages = with pkgs; [
      ripgrep
      fd
    ];
  };
}
