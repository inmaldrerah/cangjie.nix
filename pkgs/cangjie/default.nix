{ pkgs, ... }:
let
  lib = pkgs.lib;
  replaceDots = str: lib.stringAsChars (ch: if ch == "." then "_" else ch ) str;
  makeCangjiePkg = { cjver, ... }@args: let
    unwrapped = pkgs.callPackage ./unwrapped.nix args;
    dotlessVer = replaceDots cjver;
  in rec {
    "cangjie-${dotlessVer}-unwrapped" = unwrapped;
    "cangjie-${dotlessVer}" = pkgs.callPackage ./wrapper.nix { cangjie-unwrapped = unwrapped; };
  };
  makeCangjiePkgs = argList: lib.mergeAttrsList (map makeCangjiePkg argList);
  cangjiePkgs = makeCangjiePkgs [
    { cjver = "0.53.18"; cjpkg = ./Cangjie-0.53.18-linux_x64.tar.gz; }
    { cjver = "0.55.3"; cjpkg = ./Cangjie-0.55.3-linux_x64.tar.gz; }
    { cjver = "0.56.4"; cjpkg = ./Cangjie-0.56.4-linux_x64.tar.gz; }
    { cjver = "0.58.3"; }
    { cjver = "0.59.6"; }
  ];
in cangjiePkgs // {
  cangjie-unwrapped = cangjiePkgs.cangjie-0_58_3-unwrapped;
  cangjie = cangjiePkgs.cangjie-0_58_3;
}
