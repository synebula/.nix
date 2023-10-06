{ nixpkgs }:

with nixpkgs.lib; {
  # Add your library functions here
  #
  forAllSystems = genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
