{
  description = "Dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    fhs = pkgs.buildFHSUserEnv {
      name = "Micromamba environment";

      targetPkgs = _: [
        pkgs.micromamba
      ];

      profile = ''
        eval "$(micromamba shell hook --shell=bash)"
        export MAMBA_ROOT_PREFIX=~/.micromamba

        if [ ! -d ~/.micromamba ]; then
          micromamba create -f environment.yaml
        fi

        micromamba activate islp
      '';
    };
  in {
    devShells."${system}".default = fhs.env;
  };
}
