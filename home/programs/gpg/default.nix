{ pkgs, ... }:
{
  programs.gpg.enable = true;
  programs.gpg.package = pkgs.gnupg;
  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      # enableSshSupport = true;
      # enableFishIntegration = true;
    };
  };
  programs.gpg = {
    settings = {
      # Get rid of the copyright notice
      no-greeting = true;

      # Disable inclusion of the version string in ASCII armored output
      no-emit-version = true;
      # Do not write comment packets
      no-comments = false;
      # Export the smallest key possible
      # This removes all signatures except the most recent self-signature on each user ID
      export-options = "export-minimal";

      # Display long key IDs
      keyid-format = "0xlong";
      # List all keys (or the specified ones) along with their fingerprints
      with-fingerprint = true;

      # Display the calculated validity of user IDs during key listings
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity show-keyserver-urls";

      # Select the strongest cipher
      personal-cipher-preferences = "AES256";
      # Select the strongest digest
      personal-digest-preferences = "SHA512";
      # This preference list is used for new keys and becomes the default for "setpref" in the edit menu
      default-preference-list = "SHA512 SHA384 SHA256 RIPEMD160 AES256 TWOFISH BLOWFISH ZLIB BZIP2 ZIP Uncompressed";

      # Use the strongest cipher algorithm
      cipher-algo = "AES256";
      # Use the strongest digest algorithm
      digest-algo = "SHA512";
      # Message digest algorithm used when signing a key
      cert-digest-algo = "SHA512";
      # Use RFC-1950 ZLIB compression
      compress-algo = "ZLIB";

      # Disable weak algorithm
      disable-cipher-algo = "3DES";
      # Treat the specified digest algorithm as weak
      weak-digest = "SHA1";

      # The cipher algorithm for symmetric encryption for symmetric encryption with a passphrase
      s2k-cipher-algo = "AES256";
      # The digest algorithm used to mangle the passphrases for symmetric encryption
      s2k-digest-algo = "SHA512";
      # Selects how passphrases for symmetric encryption are mangled
      s2k-mode = "3";
      # Specify how many times the passphrases mangling for symmetric encryption is repeated
      s2k-count = "65011712";
    };
  };
}
