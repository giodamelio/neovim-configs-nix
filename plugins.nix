{pkgs}: {
  gitlinker-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "gitlinker.nvim";
    version = "2023-12-15";
    src = pkgs.fetchFromGitHub {
      owner = "linrongbin16";
      repo = "gitlinker.nvim";
      rev = "542f51784f20107ef9ecdadc47825204837efed5"; # Latest on branch master as of 2024-06-26
      hash = "sha256-OnlJf31dTzLOJ1tlDKH7slPnQGMZUloavEAtd/FxK0U=";
    };
    meta.homepage = "https://github.com/linrongbin16/gitlinker.nvim";
  };

  stay-centered-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "stay-centered.nvim";
    version = "2023-12-15";
    src = pkgs.fetchFromGitHub {
      owner = "arnamak";
      repo = "stay-centered.nvim";
      rev = "91113bd82ac34f25c53d53e7c1545cb5c022ade8"; # Latest on branch main as of 2024-06-26
      hash = "sha256-DDhF/a8S7Z1aR1Hg8UVgttl3je0hhn/OpZoakOeMHQw=";
    };
    meta.homepage = "https://github.com/arnamak/stay-centered.nvim";
  };

  tree-sitter-surrealdb = pkgs.tree-sitter.buildGrammar {
    language = "surrealdb";
    version = "2025-09-24";
    src = pkgs.fetchFromGitHub {
      owner = "DariusCorvus";
      repo = "tree-sitter-surrealdb";
      # Latest on branch main as of 2025-09-24
      rev = "17a7ed4481bdaaa35a1372f3a94bc851d634a19e";
      hash = "sha256-/xX5lEQKFuLQl6YxUA2WLKGX5P2GBugtYj42WCtA0xU=";
    };
  };

  vim-mint = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-mint";
    version = "2025-11-10";
    src = pkgs.fetchFromGitHub {
      owner = "IrenejMarc";
      repo = "vim-mint";
      # Latest on branch main as of 2025-11-10
      rev = "b4448a5193888a73e87da58fe7f938ce0ade1ad8";
      hash = "sha256-3LmDNCy8KL6/t5tafu7+bO5tiy/Q/kDiBhnubGpNVTs=";
    };
    meta.homepage = "https://github.com/IrenejMarc/vim-mint";
  };
}
