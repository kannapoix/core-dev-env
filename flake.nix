{
  description = "Bitcoin Core development environment";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
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

          packages = [
            pkgs.cargo
            pkgs.rustc
          ];
        };
      };
    };
}
