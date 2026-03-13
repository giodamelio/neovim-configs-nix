# Extra language plugins and tools (full variant only).
{
  pkgs,
  lib,
  vimPlugins,
  unisonPkgs ? null,
  ...
}: {
  config.vim = {
    # Eager plugins
    startPlugins = with pkgs.vimPlugins; [
      firenvim
    ];

    # Lazy plugins
    lazy.plugins = {
      "jj.nvim" = {
        package = vimPlugins.jj-nvim;
        cmd = ["JJ"];
        setupModule = "jj";
        setupOpts = {};
      };

      "vim-dadbod" = {
        package = pkgs.vimPlugins.vim-dadbod;
        cmd = ["DB" "DBUI"];
      };

      "vim-mint" = {
        package = vimPlugins.vim-mint;
        ft = ["mint"];
      };

      "vimplugin-vim-unison" = lib.mkIf (unisonPkgs != null) {
        package = unisonPkgs.vim-unison;
        ft = ["unison"];
      };

      "vim-ormolu" = {
        package = pkgs.vimPlugins.vim-ormolu;
        ft = ["haskell" "lhaskell"];
      };
    };
  };
}
