{
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = [
        pkgs.gnumake
        (pkgs.python3.withPackages (ps: [ps.pandas ps.seaborn]))
      ];
    };
  };
}