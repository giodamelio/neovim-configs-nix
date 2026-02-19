# Micro Neovim variant — smallest config with just basic editing + fuzzy finding.
{pkgs}: let
  mkNeovim = import ../mkNeovim.nix;
in
  mkNeovim {
    inherit pkgs;

    plugins = with pkgs.vimPlugins; [
      # Colorscheme
      {
        plugin = tokyonight-nvim;
        config = "colorscheme tokyonight";
      }

      # Icons (snacks picker needs these)
      nvim-web-devicons
      mini-icons

      # Fuzzy finder, file explorer, terminal, dashboard
      snacks-nvim
    ];

    runtimeDeps = [
      pkgs.ripgrep
      pkgs.fd
    ];

    extraConfig = ''
      let g:neovim_variant = 'micro'
    '';

    luaModules = [
      ../lua/basic.lua
      ../lua/plugins/micro.lua
    ];
  }
