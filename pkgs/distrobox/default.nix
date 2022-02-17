{ lib
, fetchFromGitHub
, stdenv
, makeWrapper
, podman
}:
let
  runtimePaths = [
    podman
  ];
in

stdenv.mkDerivation rec {
  pname = "distrobox";
  version = "1.2.13";

  src = fetchFromGitHub {
    owner = "89luca89";
    repo = "distrobox";
    rev = version;
    sha256 = "sha256-3u3lsa/BBLOq28ddYaXKUsKjunndW0s9fxWh6DTM9RA=";
  };
  broken = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t "$out/bin" distrobox distrobox-rm distrobox-list distrobox-init distrobox-export distrobox-enter distrobox-create

    for f in  distrobox distrobox-rm distrobox-list distrobox-init distrobox-export distrobox-enter distrobox-create; do
      wrapProgram $out/bin/$f \
        --prefix PATH : "${lib.makeBinPath runtimePaths}" 
    done

    runHook postInstall
  '';
}

