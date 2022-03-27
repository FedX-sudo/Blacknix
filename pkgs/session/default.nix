{ lib
, fetchFromGitHub
, stdenv
, yarn
}:

stdenv.mkDerivation rec {
  pname = "session-desktop";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "oxen-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tVQdsm2AO/3sDHtSOCYcReh7mMIE+BIYcp0ZrWp8CPI=";
  };

  nativeBuildInputs = [ yarn ];
  buildPhase = ''
    yarn build-release
  '';
}
