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
            pkgconf
            gcc
            libllvm
          ];

          buildInputs = with pkgs; [
            boost
            libevent
            sqlite
            capnproto
            zeromq
            qrencode
            imagemagick
            kdePackages.qtbase
            kdePackages.qttools

            python312Packages.pyzmq
            python312Packages.pycapnp

            # Required by signet getcoins.py
            python312Packages.requests

            # For test coverage
            lcov
          ];

          packages =
            (builtins.attrValues devScripts)
            ++ [
              pkgs.cargo
              pkgs.rustc
            ];

          shellHook = ''
            # Auto-link .envrc if in a directory where ../core-dev-env/templates/.envrc exists
            if [ ! -L .envrc ] && [ -f ../core-dev-env/templates/.envrc ]; then
              ln -sf ../core-dev-env/templates/.envrc .envrc
            fi

            # Auto-link .vscode if in a directory where ../core-dev-env/templates/vscode exists
            if [ ! -L .vscode ] && [ ! -d .vscode ] && [ -d ../core-dev-env/templates/vscode ]; then
              ln -sf ../core-dev-env/templates/vscode .vscode
            fi

            # Auto-link CMakeUserPresets.json if in a directory where ../core-dev-env/templates/CMakeUserPresets.json exists
            if [ ! -L CMakeUserPresets.json ] && [ -f ../core-dev-env/templates/CMakeUserPresets.json ]; then
              ln -sf ../core-dev-env/templates/CMakeUserPresets.json CMakeUserPresets.json
            fi

            if [ ! -L .gitconfig.local ] && [ -f ../core-dev-env/templates/.gitconfig.local ]; then
              ln -sf ../core-dev-env/templates/.gitconfig.local .gitconfig.local
            fi
          '';
        };
      };
    };
}
