{ lib
, stdenv
, fetchurl
}:


stdenv.mkDerivation rec {
  pname = "aesfix";
  version = "1.0.1";

  src = fetchurl { 
    url="https://citpsite.s3.amazonaws.com/memory-content/src/aesfix-1.0.1.tar.gz";
    sha256 = "sha256-exd+h2yu5qrkjwEjEC8R32WUpzhIP5pH8sdv6BzARdQ=";
  };
  buildPhase = ''
    runHook preBuild
    make 
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp aesfix $out/bin
    runHook postInstall
  '';
}

