{ pkgs, ... }:

let
  # Define a derivation for the StarDict dictionary files
  stardict-dict = { version, rev ? version, hash }:
    pkgs.stdenv.mkDerivation {
      pname = "stardict-dict";
      version = "latest";

      src = pkgs.fetchFromGitHub {
        owner = "jason9075";
        repo = "stardict-dict";
        inherit rev hash;
      };

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/dictionaries
        cp -r * $out/share/dictionaries/

        runHook postInstall
      '';

      meta = {
        description = "StarDict dictionary files for offline use.";
        longDescription = ''
          A comprehensive collection of StarDict dictionaries to enhance
          your offline dictionary experience.
        '';
        license = "Apache-2.0 license";
        homepage = "https://github.com/jason9075/stardict-dict";
      };
    };
in {
  files = stardict-dict {
    version = "v1.0";
    rev = "v1.0";
    hash = "sha256-fn+jkuhGTgtzgj41SJ53lgHkEWBviDsbscOx3YegRfE=";
  };
}
