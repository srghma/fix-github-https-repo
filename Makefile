.PHONY: test

build:
	stack build

run:
	exec .stack-work/dist/x86_64-linux-nix/Cabal-2.4.0.1/build/fix-github-https-repo/fix-github-https-repo

test:
	stack test

test_watch:
	stack test --file-watch

stack2nix:
	stack2nix . --verbose > fix-github-https-repo.nix
