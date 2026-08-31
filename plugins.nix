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

  jj-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "jj.nvim";
    version = "2026-06-23";
    src = pkgs.fetchFromGitHub {
      owner = "NicolasGB";
      repo = "jj.nvim";
      # Latest on branch main as of 2026-06-23
      rev = "f217b16699e714e32df5c7616c0f71b70d49e11f";
      hash = "sha256-/SmwZ83bgPekRFld+DgPoIEskPu9M1Kl7srNSpk4d3A=";
    };
    meta.homepage = "https://github.com/NicolasGB/jj.nvim";
  };

  # diffview-plus is a maintained fork of diffview.nvim whose vcs adapters cover
  # Jujutsu, which review.nvim's diffview backend needs; the nixpkgs diffview
  # does git and hg only. Keeps the diffview-nvim pname so it drops straight
  # into nvf's lazy spec of that name (see nvf/review.nix).
  diffview-nvim = pkgs.vimPlugins.diffview-nvim.overrideAttrs (_old: {
    # nvf's lazy spec is keyed `diffview-nvim` and matches on pname; nixpkgs
    # spells it `diffview.nvim`, which only slips through because the stock
    # module passes the package by name.
    pname = "diffview-nvim";
    version = "0.37";
    src = pkgs.fetchFromGitHub {
      owner = "dlyongemallo";
      repo = "diffview-plus.nvim";
      rev = "460b96c8285fbf0cd411bddfd9322408f37f81a5"; # v0.37
      hash = "sha256-5ZYl7D/V5tFhlojwj6EvHXnQVvfdiLxzpAlNUejLJzI=";
    };
    # Nearly every diffview module needs the plugin script to have set
    # DiffviewGlobal, so the fork's added modules fall outside the nixpkgs skip
    # list. Check the entry point only rather than chase that list.
    nvimRequireCheck = ["diffview"];
    meta.homepage = "https://github.com/dlyongemallo/diffview-plus.nvim";
  });

  qluels-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "qluels-nvim";
    version = "2026-04-22";
    src = pkgs.fetchFromGitHub {
      owner = "DeaconDesperado";
      repo = "qluels-nvim";
      # Latest on branch main as of 2026-08-30
      rev = "5711c6bd765ea73df33fd2a1795d6fdf28af45e2";
      hash = "sha256-mOvMlQBreiAa/RwjcJn8sBI261AEfV806tWHHCHtDWI=";
    };
    # Each picker backend requires its own plugin up front; picker/init.lua
    # probes them with pcall and falls back to vim.ui.select, so none are
    # available at check time.
    nvimSkipModules = [
      "qluels.picker._fzf"
      "qluels.picker._snacks"
      "qluels.picker._telescope"
    ];
    meta.homepage = "https://github.com/DeaconDesperado/qluels-nvim";
  };

  review-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "review.nvim";
    version = "2026-08-21";
    src = pkgs.fetchFromGitHub {
      owner = "giodamelio";
      repo = "review.nvim";
      # Latest on fork branch feat/diff-backends as of 2026-08-21
      rev = "d42e4df968a4f3c4b01de871be5dadbc4824fbab";
      hash = "sha256-7iGCFjCOoL7zANNUCsUGaondJJtTQUT1WYhJQIcNmz8=";
    };
    # review.picker pulls in a picker backend not present at check time.
    nvimSkipModules = ["review.picker"];
    meta.homepage = "https://github.com/giodamelio/review.nvim";
  };
}
