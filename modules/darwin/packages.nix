{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  dockutil
  xquartz
  xorg.xorgproto
  xorg.utilmacros
]
