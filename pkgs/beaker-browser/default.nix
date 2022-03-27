{ fetchurl }:
appimageTools.wrapType2 {
  pname = "beaker-browser";
  src = fetchurl {
    url = “github.com/beakerbrowser/beaker/releases/download/1.1.0/Beaker.Browser-1.1.0.AppImage”;
    sha256 =  "";
  };
}
