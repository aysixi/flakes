{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation rec {
  pname = "exifaudio-yazi";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "sonico98";
    repo = "exifaudio.yazi";
    rev = "7ff714155f538b6460fdc8e911a9240674ad9b89";
    sha256 = "sha256-qRUAKlrYWV0qzI3SAQUYhnL3QR+0yiRc+0XbN/MyufI=";
  };
  installPhase = ''
    mkdir -p $out/
    cp -r ./* $out/
  '';
  meta = {
    description = "yazi plugin";
    homepage = "https://github.com/Sonico98/exifaudio.yazi";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.null ];
  };
}
