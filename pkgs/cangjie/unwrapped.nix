{ lib, stdenv, glibc, binutils-unwrapped, gcc-unwrapped, libffi, openssl, zlib, autoPatchelfHook, cjver, cjpkg ? ./. + "/cangjie-${cjver}-linux_x64.tar.gz" }:
let
  libffi-so-4-compat = stdenv.mkDerivation {
    name = "libffi-so-4-compat";
    dontUnpack = true;
    buildInputs = [
      libffi
    ];
    postInstall = ''
      mkdir -p $out/lib
      ln -s ${libffi}/lib/libffi.so $out/lib/libffi.so.4
    '';
  };
in stdenv.mkDerivation rec {
  pname = "cangjie-unwrapped";
  version = cjver;
  src = cjpkg;
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
    gcc-unwrapped.lib
    glibc
    libffi-so-4-compat
    openssl
    zlib
  ];
}
