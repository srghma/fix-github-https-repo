{
  pkgs ? import ./nix/pkgs.nix
}:


with pkgs;
with pkgs.haskell.lib;

((import ./fix-github-https-repo.nix { inherit pkgs; }).override {
  overrides = self: super: {
    fix-github-https-repo = justStaticExecutables (
      overrideCabal super.fix-github-https-repo (
        old: {
          src = let
            additionalGitignore = "nix/**\n";
          in gitignore.gitignoreSource [additionalGitignore] ./.;
        }
      )
    );
  };
}).fix-github-https-repo
