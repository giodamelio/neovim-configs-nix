# Shared Neovim builder function.
# Each variant (full, light) calls this with its specific config.
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
