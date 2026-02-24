This flake provides an environment and tools to make Bitcoin Core development easy.
Add this flake to the local flake registry, then use it with direnv to set up the environment for your local Bitcoin Core directory.

## Features
- Provide Bitcoin Core dependencies via Nix
- Automatically symlink necessary configuration files when creating worktrees

# Requirements
- Nix
- direnv

# Setup
Clone this repository locally and add the flake to your registry:
```shell
git clone https://github.com/kannapoix/core-dev-env
cd ~/core-dev-env
nix registry add core-env $PWD
```

Reference the registry from direnv by creating a symlink to `.envrc` in your Bitcoin Core repository:
```shell
git clone https://github.com/bitcoin/bitcoin
cd bitcoin
ln -sf ~/core-dev-env/templates/.envrc .envrc
direnv allow
```
