{
  description = "A Jekyll plugin to render markdown tables as database-styled terminal output";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ ruby_3_4 bundler ];

          shellHook = ''
            export GEM_HOME="$PWD/.gem"
            export PATH="$GEM_HOME/bin:$PATH"

            bundle config set --local frozen true
            bundle install --quiet

            echo "Ruby $(ruby --version)"
          '';
        };
      }
    );
}
