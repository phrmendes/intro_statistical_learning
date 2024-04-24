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
      name = "micromamba";

      targetPkgs = pkgs:
        with pkgs; [
          micromamba
        ];

      profile = ''
        export MAMBA_ROOT_PREFIX=$(pwd)/.mamba

        eval "$(micromamba shell hook --shell=posix)"

        if [ ! -d $MAMBA_ROOT_PREFIX ]; then
          micromamba create -f env.yaml --yes
        fi

        if ! git diff --quiet -- env.yaml; then
          micromamba update -f env.yaml --yes --quiet
        fi

        micromamba activate islp --quiet
      '';
    };
  in {
    devShells."${system}".default = fhs.env;
  };
}
