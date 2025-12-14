{
  stdenv,
  lib,
  binutils,
  cangjie-unwrapped,
  gccNGPackages_15,
  glibc,
  llvmPackages,
  makeWrapper,
  buildFHSEnv,
}:

let
  fhsenv =
    (buildFHSEnv {
      name = "cangjie-env";
      targetPkgs =
        pkgs: with pkgs; [
          binutils
          gccNGPackages_15.gcc-unwrapped
          gccNGPackages_15.libatomic
          gccNGPackages_15.libgcc
          gccNGPackages_15.libssp
          gccNGPackages_15.libstdcxx
          llvmPackages.libcxxClang
        ];
    }).fhsenv;
in
stdenv.mkDerivation {
  pname = "cangjie";
  version = cangjie-unwrapped.version;
  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;
  postInstall = ''
    mkdir -p $out/bin || true
    for file in ${cangjie-unwrapped}/bin/*; do
      if [ -f "$file" ]; then
        filename=$(basename "$file")
        if [ "$filename" != "cjc" ]; then
          ln -sf "$file" "$out/bin/$filename"
        fi
      fi
    done
    makeWrapper ${cangjie-unwrapped}/bin/cjc $out/bin/cjc \
      --prefix PATH : "${fhsenv}/bin" \
      --add-flags "--sysroot ${fhsenv}"
  '';
}
