{ lib
, fetchurl
, stdenv
, ninja
, meson
, wayfire
, wlroots
, wf-config
, cairo
}:

stdenv.mkDerivation rec {
  name = "wayfire-plugins-extra";
  src = fetchurl {
    url = "https://github.com/WayfireWM/wayfire-plugins-extra/releases/download/v0.7.0/wayfire-plugins-extra-0.7.0.tar.xz";
    sha256 = "sha256-AdywQM7VUJz4+KH0bbpvYbYTIJt2uCVQkGFAJmxJIes=";
  };
  nativeBUildInputs = [ ninja meson wayfire wlroots wf-config cairo ]; 
  buildPhase = ''
    meson build --prefix=/usr --buildtype=release
    ls -l
  '';
}
