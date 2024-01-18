{
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    packages.${system} = pkgs.callPackage ./nix/scripts {stdenv = pkgs.stdenvNoCC;};

    formatter.${system} = pkgs.alejandra;

    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = [
        pkgs.gnumake
        (pkgs.python3.withPackages (ps: [ps.pandas ps.seaborn]))
      ];
    };
  };
}
