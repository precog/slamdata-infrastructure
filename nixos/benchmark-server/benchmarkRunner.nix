with import <nixpkgs>{};

stdenv.mkDerivation rec {
  name = "Benchmarking-Tool";
  version = "0.6.3";
  assetId = "6286186";

  githubToken = "${builtins.readFile /etc/nixos/githubtoken}";
  src = fetchurl {
    curlOpts = ["-L" "-H" "Accept:application/octet-stream"];
    # TODO: figure out how to not use a token here
    url = "https://${githubToken}:@api.github.com/repos/slamdata/slamdata-benchmarks/releases/assets/${assetId}";
    sha256 = "ba2af69f6b37adce6c6368d001d5bd4f30c6e3aa19e13d276e43002a3a195f38";
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/slamdata-benchmarks-runner.jar
  '';

}
