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
  nvimConfig = pkgs.neovimUtils.makeNeovimConfig {
    inherit withPython3;
    withRuby = false;
    vimAlias = true;
    viAlias = true;

    inherit plugins;

    customRC =
      extraConfig
      + builtins.concatStringsSep "\n" (map (f: "luafile ${f}") luaModules);
  };
in
  if runtimeDeps == [] then
    pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped nvimConfig
  else
    pkgs.symlinkJoin {
      name = "nvim";
      meta.mainProgram = "nvim";
      paths = [
        (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped nvimConfig)
      ] ++ runtimeDeps;
    }
