{ lib, stdenv, glibc, binutils-unwrapped, gcc-unwrapped, openssl, zlib, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "cangjie-unwrapped";
  version = "0.55.3";
  src = ./. + "/Cangjie-${version}-linux_x64.tar.gz";
  buildPhase = "";
  installPhase = ''
    runHook preInstall
    rm -r $out 2>/dev/null || true
    mkdir $out || true
    mv ./* $out/
    for file in $out/tools/bin/*; do
      if [ -f "$file" ]; then
        filename=$(basename "$file")
        ln -sf "../tools/bin/$filename" "$out/bin/$filename"
      fi
    done
    for file in $out/third_party/llvm/bin/*; do
      if [ -f "$file" ]; then
        filename=$(basename "$file")
        ln -sf "../third_party/llvm/bin/$filename" "$out/bin/$filename"
      fi
    done
    runHook postInstall
  '';
  nativeBuildInputs = [
    autoPatchelfHook
  ];
  buildInputs = [
    zlib
    gcc-unwrapped.lib
    glibc
    openssl
  ];
}
