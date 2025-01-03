{ lib, stdenv, fetchzip, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "cattpuccin-latte-gtk";
  version = "0.2.7";

  src = fetchzip {
    url =
      "https://github.com/catppuccin/gtk/releases/download/v-0.2.7/Catppuccin-Frappe-Green.zip";
    sha256 = "sha256-hgVwvxnIfDR61cwkFDfkYXyicv1Gt6mZyjmDhjKArjY=";
    stripRoot = false;
  };

  propagatedUserEnvPkgs = with pkgs; [
    pkgs.gnome-themes-extra
    gtk-engine-murrine
  ];

  installPhase = ''
    mkdir -p $out/share/themes/
    cp -r Catppuccin-Frappe-Green $out/share/themes
  '';

  meta = {
    description = "Soothing pastel theme for GTK3";
    homepage = "https://github.com/catppuccin/gtk";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.Ruixi-rebirth ];
  };
}
