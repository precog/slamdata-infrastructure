with import <nixpkgs>{};

stdenv.mkDerivation rec {
  name = "Slamdata_Launcher";
  version = "master";
  benchmark_version = "0.0.0";

  src = fetchgitPrivate {
    url = "git@github.com:slamdata/launcher.git";
    rev = "36b0ae023160ecbcdc8db26f5b1f8bc112a4eb3e";
    # to get sha256 run
    # nix-prefetch-git https://github.com/slamdata/launcher.git
    sha256 = "00fzlrywdb6y3hyb3gpahrknq9viam9g7d9fkvwsmlgk1wyjbkr3";
    fetchSubmodules = true;
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/slamdata $out/bin/slamdata
    chmod +x $out/bin/slamdata
  '';
}
