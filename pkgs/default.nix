{ pkgs ? import <nixpkgs> {} }:
import ./cangjie-bin { inherit pkgs; }
