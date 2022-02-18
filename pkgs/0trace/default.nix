{ stdenv, fetchurl, tcpdump, coreutils, lib, makeWrapper }:

let
  runtimePaths = [
    tcpdump
    coreutils
  ];
in

stdenv.mkDerivation rec {
  name = "0trace";
  src = fetchurl {
    url = "http://lcamtuf.coredump.cx/soft/0trace.tgz";
    sha256 = "sha256-vvJRC3YrCx8L3bkmH/SL1YYGrvPyADB9ALuR2lF78CQ=";
  };
  patches = [
    ./0trace.patch
  ];
  nativeBuildInputs = [ makeWrapper ];
  buildPhase = ''
    runHook preBuild
    make sendprobe
    test -f ./sendprobe
    runHook postBuild
    '';
  installPhase =  ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 -t "$out/bin" 0trace.sh sendprobe
     for f in 0trace.sh; do
      wrapProgram $out/bin/$f \
        --prefix PATH : "${lib.makeBinPath runtimePaths}" 
    done
    runHook postInstall
  '';
}
