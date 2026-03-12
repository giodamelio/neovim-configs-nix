# Full Neovim variant - all plugins, all LSP servers, all treesitter grammars.
{pkgs, ...}: {
  imports = [
    ./snacks.nix
    ./lsp.nix
    ./git.nix
    ./navigation.nix
    ./treefmt.nix
    ./nix.nix
    ./neotest.nix
    ./claude.nix
    ./extra-langs.nix
    ./neovide.nix
  ];

  config.vim = {
    # Variant identifier
    globals.neovim_variant = "full";

    # Runtime dependencies
    extraPackages = with pkgs; [
      git
      imagemagick # Snacks: For inline images
      netcat-gnu # For Unison LSP
    ];
  };
}
