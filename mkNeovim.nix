# Shared Neovim builder function using lazy.nvim for plugin management.
# Each variant (full, light) calls this with its specific config.
# Plugins are provided to generate a Nix store path map for lazy.nvim.
{
  pkgs,
  plugins, # list of plugin derivations (for path map generation)
  runtimeDeps ? [],
  luaDir, # path to lua/ directory
  extraConfig ? "",
  withPython3 ? false,
}: let
  # Extract the actual plugin derivation from either:
  # - bare derivation: tokyonight-nvim
  # - attrset with plugin key: { plugin = tokyonight-nvim; config = "..."; }
  # - attrset with name override: { plugin = treesitterBundle; name = "nvim-treesitter"; }
  extractPlugin = p:
    p.plugin or p;

  # Get the name for a plugin entry (supports name override)
  # Check for attrset with explicit override first, since derivations have a 'name' attribute
  # Fall back to 'name' if 'pname' is missing (some external plugins don't have pname)
  getPluginName = p:
    if p ? plugin
    then
      p.name or (p.plugin.pname or p.plugin.name)
    else (p.pname or p.name);

  # Generate the Lua table mapping plugin names to Nix store paths
  pluginPathMap = builtins.concatStringsSep "\n" (
    map (p: let
      drv = extractPlugin p;
      name = getPluginName p;
    in ''["${name}"] = "${drv}",'')
    plugins
  );

  # Write the nix-plugins.lua file that exposes store paths to Lua
  nixPluginsLua = pkgs.writeText "nix-plugins.lua" ''
    -- Auto-generated: maps plugin names to Nix store paths for lazy.nvim
    vim.g.nix_plugins = {
    ${pluginPathMap}
    }
  '';

  # Copy lua directory to the Nix store
  # The structure is $out/lua/{basic.lua,init.lua,plugins/,...}
  # This matches what lazy.nvim expects when searching rtp for lua/plugins/
  luaDirStore = pkgs.runCommand "nvim-lua-config" {} ''
    mkdir -p $out/lua
    cp -r ${luaDir}/* $out/lua/
  '';

  baseConfig = pkgs.neovimUtils.makeNeovimConfig {
    inherit withPython3;
    withRuby = false;
    vimAlias = true;
    viAlias = true;

    # Only lazy.nvim is bundled via Nix — it manages all other plugins
    plugins = [pkgs.vimPlugins.lazy-nvim];

    customRC =
      extraConfig
      + ''
        luafile ${nixPluginsLua}
        lua package.path = "${luaDirStore}/lua/?.lua;${luaDirStore}/lua/?/init.lua;" .. package.path
        lua vim.opt.rtp:prepend("${luaDirStore}")
        luafile ${luaDirStore}/lua/init.lua
      '';
  };

  nvimConfig =
    baseConfig
    // pkgs.lib.optionalAttrs (runtimeDeps != []) {
      wrapperArgs = baseConfig.wrapperArgs ++ ["--suffix" "PATH" ":" (pkgs.lib.makeBinPath runtimeDeps)];
    };
in
  pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped nvimConfig
