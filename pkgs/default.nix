{ pkgs ? import <nixpkgs> {} }:
(pkgs.callPackages (import ./cangjie-bin) {}) //
(pkgs.callPackages (import ./cangjie) {})
