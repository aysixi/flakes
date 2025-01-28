{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, gtk-doc
, pkg-config
, libuuid
, libtool
, readline
, gobject-introspection
, json-glib
, lvm2
, libxslt
, docbook_xsl
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "ldmtool";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "mdbooth";
    repo = "libldm";
    rev = "libldm-${version}";
    sha256 = "sha256-NtvHp/ZlvvawDBDZJDSZ3qs14q+Y8+7vUulERvAcPyI=";
  };

  patches = [
    # Remove useage of deprecrated G_PARAM_PRIVATE
    (fetchpatch {
      url = "https://github.com/mdbooth/libldm/commit/674da9bd4f482cd5e07e3f8f4b648d366b2c23bb.patch";
      sha256 = "sha256-qfjMnAe8vX2X9TUpO1kRE7tnzjTzmhnEEka/w7l/UMg=";
    })
  ];

  preConfigure = ''
    sed -i docs/reference/ldmtool/Makefile.am \
      -e 's|-nonet http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl|--nonet ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl|g'
  '';

  # glib-2.62 deprecations
  env.NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  configureScript = "sh autogen.sh";

  nativeBuildInputs = [ pkg-config autoconf automake gobject-introspection ];
  buildInputs = [
    gtk-doc
    lvm2
    libxslt.bin
    libtool
    readline
    json-glib
    libuuid
  ];

  meta = with lib; {
    description = "Tool and library for managing Microsoft Windows Dynamic Disks";
    homepage = "https://github.com/mdbooth/libldm";
    maintainers = with maintainers; [ jensbin ];
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "ldmtool";
  };
}
