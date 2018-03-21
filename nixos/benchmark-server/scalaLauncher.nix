with import <nixpkgs>{};

stdenv.mkDerivation rec {
  name = "Slamdata-Scala-Launcher";
  version = "1.0.2";
  assetId = "6539861";
  githubToken = builtins.readFile /etc/nixos/githubtoken;

  src = fetchurl {
    curlOpts = ["-L" "-H" "Accept:application/octet-stream"];
    url = "https://${githubToken}:@api.github.com/repos/slamdata/launcher/releases/assets/${assetId}";
    sha256 = "f54d48779cb1689377191ba6c417dd1d96e3681050f13414db4fe82432cc8f0a";
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/scalalauncher
    chmod +x $out/bin/scalalauncher
  '';

}
