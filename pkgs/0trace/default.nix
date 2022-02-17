{ stdenv, fetchgit, tcpdump, lib, makeWrapper }:

let
  runtimePaths = [
    tcpdump
  ];
in

stdenv.mkDerivation rec {
  name = "0trace";
  src = fetchgit {
    url = "https://gitlab.com/kalilinux/packages/0trace.git";
    sha256 = "sha256-T+8GDaqnzwgo8LIk9S6wDV/F8M+PI08GefzRJm2t7Mg=";
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
