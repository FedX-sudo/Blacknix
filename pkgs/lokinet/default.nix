{ lib
, fetchFromGitHub
, stdenv
, cmake
, pkgconfig
, libuv
, libsodium
, unbound-full
, sqlite
, curl
, doxygen
, systemd
, libevent
, sphinx-autobuild
, git
}:
stdenv.mkDerivation rec {
  pname = "lokinet";
  version = "v0.9.8";

  src = fetchFromGitHub {
    owner = "oxen-io";
    repo = pname;
    rev = version;
    sha256 = "sha256-9OywIyOXg368uMITRf+wY227AwYTxRJ0qNfXxx4OIkI=";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    pkgconfig
    libuv
    libsodium
    unbound-full
    sqlite
    curl
    doxygen
    systemd
    libevent
    sphinx-autobuild
    git
  ];
}
