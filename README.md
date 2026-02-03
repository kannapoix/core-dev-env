This flake provides an environment and tools to make Bitcoin Core development easy.
Add this flake to the local flake registry, then use it with direnv to set up the environment for your local Bitcoin Core directory.

# Requirements
- Nix
- direnv

# Setup
Clone this repository locally and add the flake to your registry:
```shell
nix registry add core-env $PWD
```

Reference the registry from direnv by creating a symlink to `.envrc` in your Bitcoin Core repository:
```shell
cd bitcoin
ln -s ~/core-dev-env/.envrc .envrc
direnv allow
```
