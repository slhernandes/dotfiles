{ stdenv, fetchFromGitHub }:
{
  sddm-theme-apple-sonoma = stdenv.mkDerivation rec {
    pname = "Apple-Sonoma-v1";
    version = "1";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/Apple-Sonoma-v1
    '';
    src = fetchFromGitHub {
      owner = "zayronxio";
      repo = "Sonoma-SDDMT";
      rev = "b418431ae350db313148db19a62b858e2e2ad3a5";
      sha256 = "nw6qi2Rq8HD4daHDYv3DJaxpy1ob/nakA71b/jf0yOc=";
    };
  };
  sddm-sugar-dark = stdenv.mkDerivation rec {
    pname = "sddm-sugar-dark-theme";
    version = "1.2";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sugar-dark
    '';
    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v${version}";
      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };
  };
}
