# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  zero_trace = pkgs.callPackage ./pkgs/0trace { };

  aesfix = pkgs.callPackage ./pkgs/aesfix { };

  aeskeyfind = pkgs.callPackage ./pkgs/aeskeyfind { };

  beef-xss = pkgs.callPackage ./pkgs/Beef-Xss { };

  distrobox = pkgs.callPackage ./pkgs/distrobox { };

  rnote = pkgs.callPackage ./pkgs/rnote { };

  wayfire-plugins-extra = pkgs.callPackage ./pkgs/wayfire-plugins-extra { };

  lokinet = pkgs.callPackage ./pkgs/lokinet { };

  blender-latest = pkgs.callPackage ./pkgs/blender-latest { };

  session-desktop = pkgs.callPackage ./pkgs/session-desktop { };

}
