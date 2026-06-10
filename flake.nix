{
  description = "A Jekyll plugin to render markdown tables as database-styled terminal output";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        rubyEnv = pkgs.bundlerEnv {
          name = "jekyll-database-tables";
          gemdir = ./.;
          groups = [ "default" "development" "test" ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [ rubyEnv ];
          shellHook = ''
            echo "Ruby $(ruby --version)"
          '';
        };
      }
    );
}
