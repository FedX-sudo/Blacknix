{ lib
, stdenv
, fetchurl
, rustPlatform
, pkg-config
, glibc
}:
rustPlatform.buildRustPackage rec {
  pname = "rnote";
  version = "0.3.5";

  src = fetchurl {
    url = "https://github.com/flxzt/rnote/releases/download/v0.3.5-hotfix-5/rnote-0.3.5-hotfix-5.tar.xz";
    sha256 = "sha256-+p+e3D8IPjwiyeV44ay8lExPQpzvweWXqjb2VOXKqjc=";
  };
  nativeBuildInputs = [ pkg-config glibc ];



  cargoSha256 = "sha256-SNkUv+8WUe0BKkIalSPjoiwhqBi8+pDEV7S+oL5iWa4=";

}
