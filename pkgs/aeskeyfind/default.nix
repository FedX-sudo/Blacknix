{ lib
, stdenv
, fetchurl
}:


stdenv.mkDerivation rec {
  pname = "aeskeyfind";
  version = "1.0";

  src = fetchurl { 
    url="https://citpsite.s3.amazonaws.com/memory-content/src/aeskeyfind-1.0.tar.gz";
    sha256 = "sha256-FBflwbYehruVJ9sfW+4ZlaDuqCR12zy8iA4Ev3Bgg+Q=";
  };
  buildPhase = ''
    runHook preBuild
    make 
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp aeskeyfind $out/bin
    runHook postInstall
  '';
}

