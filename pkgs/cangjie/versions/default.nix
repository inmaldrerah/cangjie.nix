{ pkgs, lib, ... }:
lib.map (f: pkgs.callPackage (import f) { }) [
  ./1.0.5.nix
  ./1.1.0-alpha.20260105020002.nix
]
