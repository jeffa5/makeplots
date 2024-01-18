{
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    packages.${system} = import ./nix/scripts {
      python3 = pkgs.python3;
      stdenv = pkgs.stdenv;
      lib = pkgs.lib;
    };

    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = [
        pkgs.gnumake
        (pkgs.python3.withPackages (ps: [ps.pandas ps.seaborn]))
      ];
    };
  };
}
