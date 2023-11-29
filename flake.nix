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
      name = "micromamba-fhs";

      targetPkgs = pkgs:
        with pkgs; [
          micromamba
        ];

      profile = ''
        export MAMBA_ROOT_PREFIX=./.mamba
        eval "$(micromamba shell hook --shell=posix)"

        if [ ! -d $MAMBA_ROOT_PREFIX ]; then
          micromamba create -f env.yaml --yes
        fi

        micromamba activate islp
      '';
    };
  in {
    devShells."${system}".default = fhs.env;
  };
}
