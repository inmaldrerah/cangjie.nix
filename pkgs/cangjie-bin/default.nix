{ pkgs, ... }:
let
  lib = pkgs.lib;
  replaceDots = str: lib.stringAsChars (ch: if ch == "." then "_" else ch ) str;
  makeCangjiePkg = { cjver, ... }@args: let
    unwrapped = pkgs.callPackage ./unwrapped.nix args;
    dotlessVer = replaceDots cjver;
  in rec {
    "cangjie-bin-${dotlessVer}-unwrapped" = unwrapped;
    "cangjie-bin-${dotlessVer}" = pkgs.callPackage ./wrapper.nix { cangjie-unwrapped = unwrapped; };
  };
  makeCangjiePkgs = argList: lib.mergeAttrsList (map makeCangjiePkg argList);
  cangjiePkgs = makeCangjiePkgs [
    { cjver = "0.53.18"; cjpkg = ./Cangjie-0.53.18-linux_x64.tar.gz; }
    { cjver = "0.55.3"; cjpkg = ./Cangjie-0.55.3-linux_x64.tar.gz; }
    { cjver = "0.56.4"; cjpkg = ./Cangjie-0.56.4-linux_x64.tar.gz; }
    { cjver = "0.58.3"; }
    { cjver = "0.59.6"; }
    { cjver = "0.60.4-0518"; }
    { cjver = "1.0.0"; cjpkg = ./cangjie-sdk-linux-x64-1.0.0.tar.gz; }
  ];
in cangjiePkgs // {
  cangjie-bin-unwrapped = cangjiePkgs.cangjie-bin-1_0_0-unwrapped;
  cangjie-bin = cangjiePkgs.cangjie-bin-1_0_0;
}
