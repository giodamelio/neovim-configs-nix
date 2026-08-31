# Non-plugin packages not in nixpkgs. Vim plugins live in plugins.nix.
{pkgs}: {
  qlue-ls = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "qlue-ls";
    version = "3.4.2";
    src = pkgs.fetchFromGitHub {
      owner = "IoannisNezis";
      repo = "Qlue-ls";
      tag = "v${finalAttrs.version}";
      hash = "sha256-lu0XL0I6QByVO0gSYi0Yk3EzPr6ZE9lIBkqQc28mCA4=";
    };
    cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";
    cargoBuildFlags = ["--bin" "qlue-ls"];

    meta = {
      description = "SPARQL language server";
      homepage = "https://github.com/IoannisNezis/Qlue-ls";
      mainProgram = "qlue-ls";
    };
  });
}
