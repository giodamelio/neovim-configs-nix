# Light Neovim variant - core plugins only, minimal closure size.
{...}: {
  imports = [
    ./snacks.nix
    ./lsp.nix
    ./navigation.nix
    ./treefmt.nix
    ./nix.nix
    ./neovide.nix
    ./quickfix.nix
  ];

  config.vim = {
    # Variant identifier
    globals.neovim_variant = "light";
  };
}
