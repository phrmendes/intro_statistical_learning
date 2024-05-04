{
  description = "Dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    self,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        fhs = pkgs.buildFHSUserEnv {
          name = "islp";

          profile = with pkgs; ''
            export LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH
            export LD_LIBRARY_PATH=${zlib}/lib:$LD_LIBRARY_PATH
          '';

          runScript = ''poetry shell'';

          targetPkgs = pkgs: (with pkgs; [
            poetry
            python312
            quarto
            ruff
            ruff-lsp
          ]);
        };
      in {
        devShell = fhs.env;
      }
    );
}
