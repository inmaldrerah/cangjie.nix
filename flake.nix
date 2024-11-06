{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
  in rec {
    packages."x86_64-linux" = import ./pkgs { inherit pkgs; };
    defaultPackage."x86_64-linux" = packages."x86_64-linux".cangjie;
    devShells."x86_64-linux".default = devShells."x86_64-linux".fhs;
    devShells."x86_64-linux".fhs =
      (pkgs.buildFHSEnv {
        name = "cangjie-dev-env";
        targetPkgs = pkgs: let
          cangjiePkgs = import ./pkgs { inherit pkgs; };
        in (with pkgs; [
          binutils
          gcc-unwrapped
        ]) ++ (with cangjiePkgs; [
          cangjie-unwrapped
        ]);
      }).env;
    devShells."x86_64-linux".shell =
      pkgs.mkShell {
        buildInputs = let
          cangjiePkgs = import ./pkgs { inherit pkgs; };
        in (with cangjiePkgs; [
          cangjie
        ]);
      };
  };
}
