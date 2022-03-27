{ stdenv, fetchgit, meson, cmake, pkg-config, wayfire, wf-config, glibmm, cairo, wayland-protocols, wayland, ninja, wlroots, libxkbcommon }:
stdenv.mkDerivation rec {
  name = "wayfire-plugins-extra";
  src = fetchgit {
    url = "https://github.com/WayfireWM/wayfire-plugins-extra.git";
    rev = "master";
    sha256 = "sha256-bb2zofdzSO8v2S2WAY1p8/c1Mml22FpGg0s2Ab5haRQ=";
  };
  nativeBuildInputs = [ meson ];
  buildInputs = [ cmake pkg-config wayfire wf-config cairo glibmm wayland-protocols wayland ninja wlroots libxkbcommon ];
  
}
