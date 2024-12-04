{
  description = "Dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {

        packages = [ (pkgs.python313.withPackages (p: with p; [ uv ])) ];

        shellHook = ''
          VENV=".venv/bin/activate"

          if [[ ! -f $VENV ]]; then
            uv venv
          fi

          source "$VENV"
        '';

        env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (
          with pkgs;
          [
            stdenv.cc.cc.lib
            zlib
          ]
        );
      };
    };
}
