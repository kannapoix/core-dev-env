{
  description = "Bitcoin Core development environment";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./scripts.nix
      ];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        lib,
        system,
        ...
      }: let
        devScripts = lib.filterAttrs (name: _: lib.hasPrefix "dev-" name) config.packages;
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cmake
            boost
            libevent
            sqlite
            pkgconf
            capnproto
          ];

          buildInputs = with pkgs; [
            libllvm
            gcc
            python312Packages.pyzmq
            python312Packages.pycapnp

            # Required by signet getcoins.py
            python312Packages.requests
            imagemagick

            # For test coverage
            lcov
          ];

          packages = (builtins.attrValues devScripts) ++ [
            pkgs.cargo
            pkgs.rustc
          ];

          shellHook = ''
            # Auto-link .envrc if in a directory where ../core-dev-env/.envrc exists
            if [ ! -L .envrc ] && [ -f ../core-dev-env/.envrc ]; then
              ln -sf ../core-dev-env/.envrc .envrc
            fi

            # Auto-link .vscode if in a directory where ../core-dev-env/vscode exists
            if [ ! -L .vscode ] && [ ! -d .vscode ] && [ -d ../core-dev-env/vscode ]; then
              ln -sf ../core-dev-env/vscode .vscode
            fi
          '';
        };
      };
    };
}
