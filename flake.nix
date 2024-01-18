{
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    lib = pkgs.lib;
    plotPackages = pkgs.callPackage ./nix/scripts {stdenv = pkgs.stdenvNoCC;};
  in {
    packages.${system} = lib.attrsets.filterAttrs (_: v: lib.attrsets.isDerivation v) plotPackages;

    formatter.${system} = pkgs.alejandra;

    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = [
        pkgs.gnumake
        (pkgs.python3.withPackages (ps: [ps.pandas ps.seaborn]))
      ];
    };
  };
}
