{ pkgs, lib, ... }:
lib.map (f: pkgs.callPackage (import f) { }) [
  ./1.0.5.nix
]
