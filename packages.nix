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

  swls = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "swls";
    version = "0.4.1";
    src = pkgs.fetchFromGitHub {
      owner = "SemanticWebLanguageServer";
      repo = "swls";
      tag = "swls-v${finalAttrs.version}";
      hash = "sha256-K6sDypCLHMqV/I3D/roYkBJn+XPAkckGBP8EUmPyU88=";
    };
    cargoHash = "sha256-5LK1JivA2tZzmSLFFqEENhoNYjOwVzGQhz0Up4E01dY=";
    cargoBuildFlags = ["-p" "swls"];
    cargoTestFlags = ["-p" "swls"];

    meta = {
      description = "Semantic Web Language Server for Turtle, TriG, JSON-LD and SPARQL";
      homepage = "https://github.com/SemanticWebLanguageServer/swls";
      mainProgram = "swls";
    };
  });
}
