{ stdenv, fetchFromGitHub, ruby, bundlerEnv }:
let
  # the magic which will include gemset.nix
  gems = bundlerEnv {
    name = "beef-env";
    inherit ruby;
    gemdir  = ./.;
  };
in stdenv.mkDerivation rec {
  pname = "beef";
  version = "v0.5.4.0";
  src = fetchFromGitHub {
    owner = "beefproject";
    repo = pname;
    rev = version;
    sha256 = "sha256-3rWbVN0qLjusajz+CC+yyWld1QaOuo4bVERgzD547DM=";
  };
  patches = [ ./beef.patch ];
  nativeBuildInputs = [ gems ruby ];
  installPhase = ''
    mkdir -p $out/{bin,share/beef}
    cp -r * $out/share/beef
    bin=$out/bin/beef
    # we are using bundle exec to start in the bundled environment
    cat > $bin <<EOF
    #!/bin/sh -e
    exec ${gems}/bin/bundle exec ${ruby}/bin/ruby $out/share/beef/beef "\$@"
    EOF
    chmod +x $bin
  '';

  
}
