{ pkgs, ... }:

rec {
  cangjie-unwrapped = pkgs.callPackage ./unwrapped.nix {};
  cangjie = pkgs.callPackage ./wrapper.nix { inherit cangjie-unwrapped; };
}
