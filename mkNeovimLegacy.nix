# Legacy Neovim builder function (without lazy.nvim).
# Used by micro variant which bundles plugins directly via Nix.
{
  pkgs,
  plugins,
  runtimeDeps ? [],
  luaModules,
  extraConfig ? "",
  withPython3 ? false,
}: let
  baseConfig = pkgs.neovimUtils.makeNeovimConfig {
    inherit withPython3;
    withRuby = false;
    vimAlias = true;
    viAlias = true;

    inherit plugins;

    customRC =
      extraConfig
      + builtins.concatStringsSep "\n" (map (f: "luafile ${f}") luaModules);
  };

  nvimConfig =
    baseConfig
    // pkgs.lib.optionalAttrs (runtimeDeps != []) {
      wrapperArgs = baseConfig.wrapperArgs ++ ["--suffix" "PATH" ":" (pkgs.lib.makeBinPath runtimeDeps)];
    };
in
  pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped nvimConfig
