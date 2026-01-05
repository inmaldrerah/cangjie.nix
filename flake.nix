{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      lib = pkgs.lib;
      makeFhs =
        { version }:
        let
          removeDots = str: lib.stringAsChars (ch: if ch == "." then "_" else ch) str;
          dotlessVer = removeDots version;
        in
        lib.nameValuePair "fhs-bin-${dotlessVer}"
          (pkgs.buildFHSEnv {
            name = "cangjie-bin-${version}-dev-env";
            targetPkgs =
              pkgs:
              let
                cangjiePkgs = import ./pkgs { inherit pkgs; };
              in
              [
                pkgs.binutils
                pkgs.gccNGPackages_15.gcc-unwrapped
                cangjiePkgs."cangjie-bin-${dotlessVer}-unwrapped"
              ];
          }).env;
      makeFhses =
        { versions }:
        builtins.listToAttrs (
          map (
            version:
            makeFhs {
              inherit version;
            }
          ) versions
        );
    in
    rec {
      packages."x86_64-linux" = import ./pkgs { inherit pkgs; };
      defaultPackage."x86_64-linux" = packages."x86_64-linux".cangjie-bin;
      devShells."x86_64-linux" = makeFhses {
        versions = lib.unique (lib.mapAttrsToList (name: value: value.version) packages."x86_64-linux");
      };
    };
}
